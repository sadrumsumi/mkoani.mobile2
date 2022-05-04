import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MkoaniTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline1: GoogleFonts.roboto(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.roboto(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.roboto(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      height: 1.17,
      color: Colors.black,
    ),
    headline6: GoogleFonts.roboto(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.roboto(
      fontSize: 13.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline1: GoogleFonts.roboto(
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
      color: Colors.amberAccent,
    ),
    headline2: GoogleFonts.roboto(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.roboto(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 1.17,
      color: Colors.white,
    ),
    headline6: GoogleFonts.roboto(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return Colors.black;
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          titleTextStyle: MkoaniTheme.darkTextTheme.headline3,
          backgroundColor: const Color(0xff39748E),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
        ),
        textTheme: darkTextTheme,
        radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(const Color(0xFFC4C4C4))),
        cardTheme: const CardTheme(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFF2B705)))),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey[600]),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black,
            )),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.blue,
            )),
            border: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black,
            )),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black,
            ))),
        scaffoldBackgroundColor: const Color(0xff39748E));
  }
}
