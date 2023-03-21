import 'dart:io';
import 'dart:ui';
import 'package:bluechat/const/colors.dart';
import 'package:bluechat/const/screenconfig.dart';
import 'package:bluechat/functions/EncryptUtil.dart';
import 'package:bluechat/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:bubble_lens/bubble_lens.dart';
import 'package:bluechat/functions/funcs.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:bluechat/functions/database.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:bluechat/screens/messages.dart';
import 'package:bluechat/models/messagesModel.dart';
import 'dart:math';
import 'package:sqflite_sqlcipher/sqflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {



  @override
  void dispose() {
    super.dispose();
    Funcs().stopDiscovery();
    Funcs().stopAdvertising();
  }


  @override
  void initState() {
    super.initState();
    Funcs().permissions();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => startScan(context));

  }

  startScan(BuildContext ctx) async{
    EncryptUtil utils=EncryptUtil();
    await utils.gk();
    final String publickey= await utils.pk();


    final User uname = (await BluDatabase.readUser(1));
      final userstringid = uname.username+"."+uname.deviceID+"."+uname.profilePhoto.toString()+"."+publickey;

      Funcs().startAdvertising(userstringid,ctx);
      await Future.delayed(Duration(seconds: 10));
      Funcs().startDiscovery(userstringid,ctx);
      //print("second");
  }
  
  

  @override
  Widget build(BuildContext context) {


    final providerData = Provider.of<MainProvider>(context, listen: false);
    print("provider data ${providerData.username}");
    if(providerData.username == "qwerty") {
      providerData.setUserDataFromDB();
    }

    return Scaffold(
      body: Stack(
        children: [

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/circle-grow.json',
                  height: 700,
                  width: 700,
                  repeat: true,
                ),
              ],
            ),
          ),

          Positioned(
            top: screenHeight(context)*0.050,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'BluChat',
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white70
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BubbleLens(
                      width: screenWidth(context),
                      height: screenHeight(context)/1.5,
                      duration: Duration(milliseconds: 50),
                      paddingX: 0,
                      paddingY: 0,
                      highRatio: 0.3,
                      lowRatio: 0.4,
                      widgets: [

                        for (var i = 0; i < context.watch<MainProvider>().nearbydevices.length; i++)

                        GestureDetector(
                          onTap: () {
                            //print(providerData.nearbydevices[i]);
                            String idstring = providerData.nearbydevices[i];
                            List<String> parts = idstring.split(".");

                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: false,
                                context: context,
                                builder: (context) => drawer(parts[0],parts[1],int.parse(parts[2]),parts[3],parts[4])
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            color: [
                              Colors.white70,
                              Colors.white60,
                              Colors.white54
                            ][i % 3],
                            child: Image.asset(
                                "assets/avatars/${int.parse(providerData.nearbydevices[i].split('.')[2].split(':')[0])}.png",
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Image.asset('assets/avatars/06.png');
                              },
                            ),
                          ),
                        ),
                    ]
                  ),

                  ElevatedButton(
                      onPressed: () async {
                          /*
                          await BluDatabase.instance.close();

                          Process.run('busybox', ['shred','-z','-n','6','-u','${await getDatabasesPath()}/bluchat.db']).then((ProcessResult results) {
                              print(results.stdout.toString());
                          });
              //Nearby().stopAllEndpoints();
                        //print(providerData.getMessages("hackgod", "FRUG"));

                           */


                      },
                    child: Text("Reset Databases"),
                      ),


                  // SizedBox(height: 50),
                ],
              ),
          ),


          AnimatedOpacity(
              opacity: providerData.username == "qwerty" ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: const SizedBox(),
              ),
          )

        ],
      ),
    );
  }

  Widget drawer(String name, String deviceID, int photoID,String publicKey, endpointID) {
    final userstringid = name+"."+deviceID+"."+photoID.toString();

    final providerData = Provider.of<MainProvider>(context, listen: false);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 26),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white.withOpacity(0.8)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.transparent
                ),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(name, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 20,fontWeight: FontWeight.w700),),
                    subtitle: providerData.connectedDevices.contains(endpointID)
                      ?
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(userName: name,photoID: photoID,endpointId: endpointID,publicKey: publicKey)));
                      },
                      child: Text("Message"),
                      )
                    :
                    ElevatedButton(
                      onPressed: () {
                        Funcs().sendConnectionRequest(endpointID,userstringid,context);
                      },
                      child: Text("Connect"),
                    ),
                    trailing: Image.asset("assets/avatars/${photoID}.png",height: 80,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset('assets/avatars/06.png');
                      }),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
