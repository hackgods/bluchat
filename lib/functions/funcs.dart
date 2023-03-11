import 'package:device_info/device_info.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

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
          providerData.addNearbyDevices(name);
          //print(providerData.nearbydevices.toString());

          print('Endpoint found: $name');

        },
        onEndpointLost: (name) {
          print('Endpoint lost: $name');
          // remove the disconnected device ID from nearbydevices list
          providerData.nearbydevices.remove(name);
          providerData.notifyListeners();
        },
        serviceId: "com.hg.bluechat.bluechat",
      );
    } catch (e) {
      print('Error starting discovery: $e');
    }
  }

  Future<void> startAdvertising(String deviceID) async {
    try {
      await Nearby().startAdvertising(
        deviceID,
        strategy,
        onConnectionInitiated: (name, info) async {
          print('Connection initiated: $name');

        },
        onConnectionResult: (id, status) {
          print('Connection result: $id, $status');
        },
        onDisconnected: (name) {
          print('Disconnected: $name');

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





}