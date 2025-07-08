
import 'package:flutter/material.dart';

final darkThem = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(26, 26, 26, 1.0),
    primarySwatch: Colors.cyan,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(26, 26, 26, 1.0)),
    dividerTheme: const DividerThemeData(color: Color.fromRGBO(
        49, 0, 0, 1.0)),
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromRGBO(225, 178, 178, 1.0)),
        backgroundColor: Color.fromRGBO(26, 26, 26, 1.0),
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(225, 178, 178, 1.0),
            fontSize: 24,
            fontWeight: FontWeight.w700 )
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
        titleMedium: TextStyle(
            color: Color.fromRGBO(225, 178, 178, 1.0),
            fontSize: 20,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
            fontSize: 24,
            fontWeight: FontWeight.w900),
        bodyMedium:  TextStyle(
            color: Color.fromRGBO(225, 178, 178, 1.0),
            fontSize: 16,
            fontWeight: FontWeight.w400
        ),
        bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400
        ),
        displayLarge: TextStyle(
            color: Colors.greenAccent,
            fontSize: 32,
            fontWeight: FontWeight.w900
        ),
        displayMedium: TextStyle(
            color: Colors.redAccent,
            fontSize: 32,
            fontWeight: FontWeight.w900
        )

    )
);