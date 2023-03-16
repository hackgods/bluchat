import 'package:device_info/device_info.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:bluechat/models/messagesModel.dart';
import 'package:bluechat/functions/database.dart';
import 'package:intl/intl.dart';

class Funcs {

  deviceData() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //print('Running on ${androidInfo.id}');
    //print('Running on ${androidInfo.androidId}');
    return androidInfo.androidId;
  }



  permissions() async{

    if(await Permission.location.serviceStatus.isEnabled) {
      print("location is enabled");
      //Nearby().enableLocationServices();
    } else {
      var locStatus = await Permission.location.status;
      if(locStatus.isGranted) {
        print("location is granted and enabled");
      } else if (locStatus.isDenied) {
        Map<Permission,PermissionStatus> locstatus = await [
          Permission.location,
        ].request();

        // Nearby().enableLocationServices();
      }
    }

    if (await Nearby().checkBluetoothPermission()) {
      print("ble enabled");
    } else {
      Nearby().askBluetoothPermission();
    }

  }




  final Nearby _advertiser = Nearby();
  final Nearby _discoverer = Nearby();
  final List<String> _messages = [];
  final List<String> nearbydevices = [];
  final Strategy strategy = Strategy.P2P_CLUSTER;


  Future<void> startDiscovery(String deviceID, BuildContext ctx) async {
    try {
      final providerData = Provider.of<MainProvider>(ctx, listen: false);
      await Nearby().startDiscovery(
        deviceID,
        strategy,
        onEndpointFound: (id, name, serviceId) async {
          providerData.addNearbyDevices("${name}.${id}");
          //print(providerData.nearbydevices.toString());

          print('Endpoint found: $name:${id}');

        },
        onEndpointLost: (name) {
          print('Endpoint lost: $name');
          // remove the disconnected device ID from nearbydevices list
          providerData.nearbydevices.removeWhere((item) => item.contains("${name}"));
          //providerData.nearbydevices.remove("${name}.${id}");
          providerData.notifyListeners();
        },
        serviceId: "com.hg.bluechat.bluechat",
      );
    } catch (e) {
      print('Error starting discovery: $e');
    }
  }

  Future<void> startAdvertising(String deviceID,BuildContext ctx) async {
    try {
      await Nearby().startAdvertising(
        deviceID,
        strategy,
        onConnectionInitiated: (endpointId, info) {
          showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
              title: Text("Accept connection request?"),
              actions: [
                ElevatedButton(
                  child: Text("Decline"),
                  onPressed: () {
                    Nearby().rejectConnection(endpointId);
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text("Accept"),
                  onPressed: () {
                    Nearby().acceptConnection(endpointId,
                        onPayLoadRecieved:(String id, Payload payload) {
                          PayloadReceived(id,payload,ctx);
                        } );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        onConnectionResult: (id, status) {
          print('Connection result: $id, $status');
          final providerData = Provider.of<MainProvider>(ctx, listen: false);
          providerData.addconnectedDevices(id);
          providerData.notifyListeners();
        },
        onDisconnected: (id) {
          print('Disconnected: $id');
          final providerData = Provider.of<MainProvider>(ctx, listen: false);
          providerData.connectedDevices.remove(id);
          providerData.notifyListeners();
        },
        serviceId: "com.hg.bluechat.bluechat",
      );
    } catch (e) {
      print('Error starting advertising: $e');
    }
  }

  Future<void> stopDiscovery() async {
    try {
      await Nearby().stopDiscovery();

    } catch (e) {
      print('Error stopping discovery: $e');
    }
  }

  Future<void> stopAdvertising() async {
    try {
      await Nearby().stopAdvertising();
    } catch (e) {
      print('Error stopping advertising: $e');
    }
  }


  Future<void> sendConnectionRequest(String endpointId,String deviceId,BuildContext ctx) async {
    try {
      await Nearby().requestConnection(
        deviceId,
        endpointId,
        //Payload.fromBytes(utf8.encode("request")),
        onConnectionInitiated: (endpointId, info) {
          // called when connection is initiated
          showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
              title: Text("Accept connection request?"),
              actions: [
                ElevatedButton(
                  child: Text("Decline"),
                  onPressed: () {
                    Nearby().rejectConnection(endpointId);
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text("Accept"),
                  onPressed: () {
                    Nearby().acceptConnection(endpointId,
                        onPayLoadRecieved:(String id, Payload payload) {
                          PayloadReceived(id,payload,ctx);
                        });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        onConnectionResult: (endpointId, status) {
          print('Connection result: $endpointId, $status');

          final providerData = Provider.of<MainProvider>(ctx, listen: false);
          providerData.addconnectedDevices(endpointId);
          providerData.notifyListeners();
        },
        onDisconnected: (endpointId) {
          print('Disconnected: $endpointId');
          final providerData = Provider.of<MainProvider>(ctx, listen: false);
          providerData.connectedDevices.remove(endpointId);
          providerData.notifyListeners();
        },
      );
    } catch (e) {
      print("Error sending connection request: $e");
    }
  }


  Future<void> acceptConnectionRequest(String endpointId) async {
    try {
      await Nearby().acceptConnection(
        endpointId,
          onPayLoadRecieved: (endpointId, payload) {
            if (payload.type == PayloadType.BYTES) {
              String message = String.fromCharCodes(payload.bytes?.toList() ?? []);
              print('Received message: $message');
            }
          }
      );
    } catch (e) {
      print("Error accepting connection request: $e");
    }
  }


  void PayloadReceived(String endpointId, Payload payload, BuildContext ctx) async {
    final providerData = Provider.of<MainProvider>(ctx, listen: false);

    if (payload.type == PayloadType.BYTES) {
      String message = String.fromCharCodes(payload.bytes?.toList() ?? []);
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(now);

      final Messages msgdata = Messages(sender: endpointId,receiver: providerData.username,message: message,timestamp: formattedTime.toString());

      await providerData.addMessage(msgdata).then((value) {
                providerData.notifyListeners();
      });

      //providerData.addNewMessages(message);
      //providerData.notifyListeners();
    }
  }




  void showSnackbar(dynamic a,BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }




  }

