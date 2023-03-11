import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/functions/database.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:nearby_connections/nearby_connections.dart';

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

   addNearbyDevices(String name) {
     if (!nearbydevices.contains(name)) {
       nearbydevices.add(name);
     }
     notifyListeners();
   }






}
