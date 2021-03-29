import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurants/pages/delivery/delivery.dart';
import 'package:restaurants/pages/message.dart';
import 'package:restaurants/pages/money/money.dart';
import 'package:restaurants/pages/orders/myorders.dart';
import 'package:restaurants/pages/report.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Pages
import 'package:restaurants/pages/items/additems.dart';
import 'package:restaurants/pages/items/items.dart';
import 'package:restaurants/pages/settings.dart';
import 'pages/sign/login.dart';
import './pages/home.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

SharedPreferences sharedPrefs;
String resid;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized(); // mandatory when awaiting on main
  await Firebase.initializeApp();
  sharedPrefs = await SharedPreferences.getInstance();
  resid = sharedPrefs.getString("id");
  runApp(MyApp(resid: resid));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final resid;
  MyApp({this.resid});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          // primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          primaryColor: Color(0xffFE463D),
          textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 15),
              headline3: TextStyle(fontSize: 25, color: Colors.red))),
      home: resid == null ? Login() : Home(),
      routes: {
        "login": (context) => Login(),
        "home": (context) => Home(),
        "items": (context) => Items(),
        "additems": (context) => AddItem(),
        "settings": (context) => Settings(),
        "delivery": (context) => Delivery(),
        "orders": (context) => MyOrders(),
        "message": (context) => Message(),
        "report": (context) => Report(),
        "bill": (context) => Bill()
      },
    );
  }
}
