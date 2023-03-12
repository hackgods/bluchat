import 'package:bluechat/const/apptheme.dart';
import 'package:bluechat/functions/database.dart';
import 'package:flutter/material.dart';
import 'package:bluechat/screens/intro.dart';
import 'package:bluechat/screens/home.dart';
import 'package:bluechat/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:bluechat/functions/rsautils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BluDatabase.instance.database;
  print("checking user presence");
  User? uname;
  
  RsaUtils rsautils=new RsaUtils();

  await rsautils.genKey();
  print(rsautils.pk);
  print(rsautils.sk);

  String a=await rsautils.encryptMsg("fuck you in the ass");
  print("encrypted message: $a");

  String b=await rsautils.decryptMsg(a);
  print("decrypted message: $b");

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


