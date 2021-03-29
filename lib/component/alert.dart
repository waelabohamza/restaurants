import 'package:flutter/material.dart';

showdialogall(context, String mytitle, String mycontent) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(mytitle),
          content: Text(mycontent),
          actions: <Widget>[
            FlatButton(
              child: Text("done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
showLoading(context) {
  return showDialog(
    barrierDismissible: false ,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("الرجاء الانتظار "),
          content: Container(  height: 50, child: Center(child: CircularProgressIndicator(),)),
        );
      });
}