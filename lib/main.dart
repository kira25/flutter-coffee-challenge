import 'package:coffee_challenge/helpers/colors.dart';
import 'package:coffee_challenge/pages/coffee_concept_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Challenge',
      theme: ThemeData(
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.1)),
        fontFamily: GoogleFonts.poppins().fontFamily,
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        primaryColor: kprimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CoffeeConceptPage(),
    );
  }
}
