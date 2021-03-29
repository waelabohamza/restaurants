import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/component/mydrawer.dart';
import 'package:restaurants/pages/delivery/delivery.dart';
import 'package:restaurants/pages/orders/myorders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurants/component/getnotify.dart';
import 'package:restaurants/main.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = new Crud();
  var data = {};
  var image;
  var selectall;
  var resid;
  var balance;
  var countitems;
  var countorders, countdelivery;
  bool loading = false;

  Future getCount() async {
    setState(() {
      loading = true;
    });
    resid = sharedPrefs.get('id');
    data = {"resid": resid};
    image = sharedPrefs.getString("image");
    selectall = await crud.readDataWhere("countallres", resid);
    print("==============================");
    print(selectall);
    print("==============================");
    setState(() {
      countitems = selectall['items'];
      countorders = selectall['orders'];
      countdelivery = selectall['delivery'];
      balance = double.parse(selectall['balance']).toStringAsFixed(3);
      loading = false;
    });
  }

 
  setLocal() async {
    await Jiffy.locale("ar");
  }

  @override
  void initState() {
    super.initState();
    // checkLogin();
    requestPermissions();
    getLocalNotification();
    getNotify(context, resid);
    getCount();
    setLocal();
  }

  // @override
  // void dispose() async{
  //    await flutterLocalNotificationsPlugin.cancelAll();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(
                    "لوحة التحكم",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(child: Container()),
                  Text("الرصيد : ${balance} ", style: TextStyle(fontSize: 16))
                ],
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("message");
                    })
              ],
            ),
            drawer: MyDrawer(balance: balance),
            body: loading == false
                ? WillPopScope(
                    child: ListView(
                      children: <Widget>[
                        image == null
                            ? Center(child: CircularProgressIndicator())
                            : CachedNetworkImage(
                                imageUrl:
                                    "${crud.server}/upload/reslogo/${image}",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                height: mdw - (20 / 100) * mdw,
                                width: mdw,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: mdw * 0.47,
                              height: mdw * 0.5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return MyOrders();
                                  }));
                                },
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "images/home/shipping.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    //
                                    Text(
                                      "الطلبات",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text("$countorders")
                                  ],
                                )),
                              ),
                            ),
                            Container(
                              width: mdw * 0.47,
                              height: mdw * 0.5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed('items',
                                      arguments: {"resid": resid});
                                },
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "images/home/food.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "الوجبات",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text("${countitems}")
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: mdw * 0.47,
                              height: mdw * 0.5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return Delivery(resid: resid);
                                  }));
                                },
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "images/home/delivery.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "العمال",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text("${countdelivery}")
                                  ],
                                )),
                              ),
                            ),
                            Container(
                              width: mdw * 0.47,
                              height: mdw * 0.5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("report");
                                },
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "images/home/report.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "التقارير",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(" ")
                                  ],
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    onWillPop: _onWillPop)
                : Center(child: CircularProgressIndicator())));
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () => exit(0),
                //  onPressed: () =>   Navigator.of(context).pop(true)  ,
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
