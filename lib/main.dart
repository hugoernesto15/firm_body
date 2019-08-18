import 'package:flutter/material.dart';
import 'screens/root_page.dart';
import 'package:firm_body_flutter/services/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firm Body',
      theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 30.0),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.black,
            textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: Colors.black87),
      home: RootPage(auth: Auth()),
    );
  }
}
