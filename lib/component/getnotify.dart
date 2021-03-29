import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

getTokenDevice() async {
  String mytoken;
  await _firebaseMessaging.getToken().then((String token) {
    print("=======================");
    print("token 1 ${token}");
    print("=======================");
    if (token == null) {
      _firebaseMessaging.getToken().then((String newtoken) {
        mytoken = newtoken;
        print(" 2 retry token");
      });
    } else {
      mytoken = token;
    }
    print("=======================");
    print("token  2 ${mytoken}");
    print("=======================");
  });
  return mytoken;
}

void redirectPage(RemoteMessage message, BuildContext context,
    [var resid]) async {
  String page_name = message.data["page_name"].toString();
  // String page_id = message.data["page_id"].toString();
  if (page_name == "orders") {
    Navigator.of(context).pushNamed("orders");
  }
}

getNotify(BuildContext context, resid) {
  FirebaseMessaging.onMessage.listen((message) {
    String title = message.notification.title.toString();
    String body = message.notification.body.toString();
    print("onMessage res: $message");
    print("onMessage res: ===================================================");
    showNotification( title   , body );
    redirectPage(message, context, resid);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("onResume: $message");
    redirectPage(message, context, resid);
  });
}

// //==============================================
// // =================== For Local Notifcation
getLocalNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS);
flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: selectNotification);

}
 void requestPermissions() {

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
    // At the second last line ‘selectNotification: onSelectNotification’. This line is responsible for the action which is going to be happen when we will click on the Notification. This method must return Future and this method must have a string paramter which will be payload.
Future selectNotification(String payload ) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    print(payload) ;

    // var resid = sharedPrefs.getString("id") ;
    // navigatorKey.currentState.pushNamed("items" , arguments: {
    //        "resid" : resid
    // }) ;

}
Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
    // var resid = sharedPrefs.getString("id") ;

    //    navigatorKey.currentState.pushNamed("items" , arguments: {
    //        "resid" : resid
    // }) ;
}
// Show Notifcation
Future<void> showNotification(String title ,String  body ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title , body , platformChannelSpecifics,
        payload: 'item');
  }
