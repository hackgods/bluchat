import 'package:bluechat/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundMain,
    colorSchemeSeed: const Color(0xFF00A4d8),
    textTheme: GoogleFonts.poppinsTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A4d8), // background (button) color
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                side: BorderSide(width: 0,color: Colors.transparent),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)),
                textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                  fontWeight: FontWeight.w400
                )// foreground (text) color
                                )),
    bottomSheetTheme: BottomSheetThemeData(
      //backgroundColor: AppColors.lighterGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    )
  );
}