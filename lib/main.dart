import 'package:bluechat/const/apptheme.dart';
import 'package:bluechat/functions/database.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:bluechat/screens/intro.dart';
import 'package:bluechat/screens/home.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:bluechat/functions/EncryptUtil.dart';
import 'dart:convert';


import 'dart:io'; // For Platform.isX
import 'package:path/path.dart' as path;




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BluDatabase.instance.database;
  print("checking user presence");
  User? uname;



//on each side, have one encrypt utils
  EncryptUtil lucas=EncryptUtil();
  EncryptUtil hackgods=EncryptUtil();
//call gk to generate keypair, if old keys cannot be trusted, call this again and generate new secret key
  await lucas.gk();
  await hackgods.gk();



  print("Alice Public Key: ${base64Encode((await lucas.aliceKeyPair.extractPublicKey()).bytes)}");
  print("Alice Private Key: ${base64Encode(await lucas.aliceKeyPair.extractPrivateKeyBytes())}");

  print("Bob Public Key: ${base64Encode((await hackgods.aliceKeyPair.extractPublicKey()).bytes)}");
  print("Bob Private Key: ${base64Encode(await hackgods.aliceKeyPair.extractPrivateKeyBytes())}");

//serialize publickey and send it to hackgods
//lucas pass hackgods' publickey to func ss to generate secret key
  await lucas.ss(await hackgods.aliceKeyPair.extractPublicKey());
//serialize publickey and send it to lucas
//hackgods pass lucas' publickey to func ss to generate secret key
  await hackgods.ss(await lucas.aliceKeyPair.extractPublicKey());
//up to this point, lucas and hackgods have the same secret key

  print("Alice Shared Secret: ${base64Encode(await lucas.sk.extractBytes())}");
  print("Bob Shared Secret: ${base64Encode(await hackgods.sk.extractBytes())}");

  String test='some plain text message';

//lucas encrypt test message //lucas serialize SecretBox and send it to hackgods
  SecretBox box1=await lucas.enc(test);
  print("Encrypt Test Alice: ${base64Encode(box1.cipherText)}");

//hackgods recieve the Secretbox and unserialize it then decrypt the message
  String Plaintext=await hackgods.dec(box1);
  print("Decrypt Test Bob: $Plaintext");








  try {
    uname = (await BluDatabase.readUser(1));
    print(uname == null ? "NuLL" : "${uname.username}");


  } on Exception catch (e) {
    print('Exception details:\n $e');
    print(uname);
  } catch (e, s) {
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
    print(uname);
  }

  runApp(
    ChangeNotifierProvider<MainProvider>(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: uname == null ? Intro() : Home(),
      ),
        create: (_) => MainProvider())
  );
}


