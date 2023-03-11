import 'package:bluechat/functions/database.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bluechat/screens/home.dart';
import 'package:bluechat/functions/funcs.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'dart:math';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({Key? key}) : super(key: key);

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  User? user;



  @override
  Widget build(BuildContext context) {
    //final providerData = Provider.of<MainProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Choose a Username',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
              'Create a username to get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                maxLength: 15,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'[^a-zA-Z0-9_]'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length > 15) {
                    return 'Username must be less than or equal to 15 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  _username = value;
                },
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final deviceID = await Funcs().deviceData();
                  int randomNumber = Random().nextInt(20);
                  final User userdata = User(username: _username,deviceID: deviceID,profilePhoto: randomNumber);
                  await BluDatabase.createUser(userdata).then((value) {
                    //providerData.setUsername(userdata.username);
                    final providerData = Provider.of<MainProvider>(context, listen: false);
                    providerData.setUserDataFromDB();


                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Home()));
                  });
                  //final User uname = (await BluDatabase.readUser(1));
                  //print(uname.username);

                }
              },
              child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
