import 'dart:ui';
import 'package:bluechat/const/colors.dart';
import 'package:bluechat/const/screenconfig.dart';
import 'package:bluechat/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:bluechat/functions/funcs.dart';
class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  @override
  Widget build(BuildContext context) {
    Funcs().permissions();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/blobs.riv",
            fit: BoxFit.fitWidth,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),

          Positioned(
            top: 100,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white70
                  ),
                ),
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
                Lottie.asset(
                  'assets/bluetooth.json',
                  height: 300,
                  width: 300,
                  repeat: true,
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          Positioned(
            left: screenWidth(context) * 0.075,
            bottom: 50,
            width: screenWidth(context) * 0.85,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UsernameScreen()));
              },
              child: Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
