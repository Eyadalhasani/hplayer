import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 242, 242, 242),
  hintColor:const Color.fromARGB(255, 192, 192, 192),
  scaffoldBackgroundColor: const Color.fromARGB(255, 242, 242, 242),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  textTheme:const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: Colors.black,
      overflow: TextOverflow.ellipsis
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  ),
  listTileTheme: ListTileThemeData(
    dense: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    tileColor: const Color.fromARGB(218, 203, 198, 198),
  ),


);

ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  brightness:Brightness.dark,
  primaryColor:const Color.fromARGB(100, 60, 63, 65),
  hintColor:const Color.fromARGB(39, 89, 90, 90),
  scaffoldBackgroundColor: const Color.fromARGB(100, 43, 43, 43),
  textTheme:const  TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  ),
  listTileTheme: ListTileThemeData(
    dense: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    tileColor: const Color.fromARGB(218, 134, 134, 134),
  ),
);