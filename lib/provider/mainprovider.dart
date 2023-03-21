import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/functions/database.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:bluechat/models/messagesModel.dart';

import '../functions/EncryptUtil.dart';


class MainProvider extends ChangeNotifier {

  String _data = 'Initial value';
  String get data => _data;
  void updateData(String newValue) {
    _data = newValue;
    notifyListeners();
  }


  String username = "qwerty";
  String deviceID = "000000";

   setUserData(User user) async{
    username = user.username;
    deviceID = user.deviceID;
    notifyListeners();
  }

   setUserDataFromDB() async{
    final User uname = (await BluDatabase.readUser(1));
    username = uname.username;
    deviceID = uname.deviceID;
    notifyListeners();
  }


  List<String> nearbydevices = [];
  List<String> connectedDevices = [];

   addNearbyDevices(String name) {
     if (!nearbydevices.contains(name)) {
       nearbydevices.add(name);
     }
     notifyListeners();
   }

  addconnectedDevices(String name)
  {
    if (!connectedDevices.contains(name))
    {
      connectedDevices.add(name);
    }
    notifyListeners();
  }

  /*
  final List<String> messages = [];


   addNewMessages(String msgtext) {
     messages.insert(0, msgtext);
     notifyListeners();
   }
   */


  List<Messages> _messagesList = [];

  //Stream<List<Messages>> get messagesStream => BluDatabase.instance.messagesStream();

  Future<void> addMessage(Messages message) async {
    await BluDatabase.instance.insertMessage(message);
    _messagesList.add(message);
    notifyListeners();
  }

  Future<void> deleteMessage(Messages message) async {
    await BluDatabase.instance.deleteMessage(message.id!);
    _messagesList.remove(message);
    notifyListeners();
  }

  List<Messages> get messagesList => _messagesList;

  Future<void> loadMessages(String sender, String receiver) async {
    List<Messages> messages = await BluDatabase.instance.getMessages(sender, receiver);
    _messagesList = messages;
    notifyListeners();
  }


  EncryptUtil utils=EncryptUtil();


}
