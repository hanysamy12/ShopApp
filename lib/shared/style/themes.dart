import 'package:flutter/material.dart';
import 'package:shop_app/shared/style/colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  //All Colors
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.black, size: 25),
  ),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepOrange,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      elevation: 40.0),
  iconTheme: const IconThemeData(color: Colors.blue, size: 25),


);

ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: defaultBlackColor,
  textTheme: const TextTheme(
      bodySmall: TextStyle(
         // fontSize: 14,
          //fontWeight: FontWeight.w600,
          color: Colors.white),bodyMedium: TextStyle(
    // fontSize: 14,
    //fontWeight: FontWeight.w600,
      color: Colors.white),
  bodyLarge: TextStyle(
    // fontSize: 14,
    //fontWeight: FontWeight.w600,
      color: Colors.white),),
  appBarTheme: AppBarTheme(
    backgroundColor: defaultBlackColor,
    titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold),
    iconTheme: const IconThemeData(color: Colors.white70, size: 25),
  ),
 /* floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: defaultBlackColor,
  ),*/

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      // selectedItemColor: Colors.deepOrange,
      backgroundColor: Colors.black12,
      unselectedItemColor: Colors.white,
      elevation: 40.0),
  iconTheme: const IconThemeData(color: Colors.white, size: 25),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    iconColor: Colors.white70,
    prefixIconColor: Colors.white70,
  ),


);