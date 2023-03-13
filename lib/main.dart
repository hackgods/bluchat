import 'package:bluechat/const/apptheme.dart';
import 'package:bluechat/functions/database.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:bluechat/screens/intro.dart';
import 'package:bluechat/screens/home.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:bluechat/functions/rsautils.dart';
import 'package:bluechat/functions/EncryptUtil.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BluDatabase.instance.database;
  print("checking user presence");
  User? uname;

  //genkeys();
  EncryptUtil eu1=EncryptUtil();
  EncryptUtil eu2=EncryptUtil();
  await eu1.gk();
  await eu2.gk();

  //exchange publickey, publickey is safe to send through air
  await eu1.ss(await eu2.aliceKeyPair.extractPublicKey());
  await eu2.ss(await eu1.aliceKeyPair.extractPublicKey());

  String test='fuck you dip shit';

  print("shared secret the same?  \n ss1 ${await eu1.sk.extractBytes()} \n ss2 ${await eu2.sk.extractBytes()}");

  SecretBox box1=await eu1.enc(test.codeUnits,eu1.sk);
  print("encrypt test: ${box1.cipherText}");
  List<int> Plaintext=await eu2.dec(box1, eu2.sk);
  print("decrypt test: ${new String.fromCharCodes(Plaintext)}");







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


