import 'package:flutter/material.dart';
import 'package:restaurants/pages/orders/ordersdone.dart';
import 'package:restaurants/pages/orders/ordersprepare.dart';
import 'package:restaurants/pages/orders/orderswait.dart';

// My Import

class MyOrders extends StatefulWidget {
  
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  PageController _controller;
  var currentindex = 0;

  @override
  void initState() {
    _controller = new PageController(initialPage: 0, viewportFraction: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الطلبات"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red,
          selectedItemColor: Colors.white,
          currentIndex: currentindex,
          onTap: (val) {
            setState(() {
              currentindex = val;
            });
            _controller.jumpToPage(currentindex);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.online_prediction_rounded),
                label: "بانتظار الموافقة"),
            BottomNavigationBarItem(
                icon: Icon(Icons.online_prediction_rounded),
                label: "قيد التحضير"),
            BottomNavigationBarItem(
                icon: Icon(Icons.online_prediction_rounded), label: "تم التوصيل"),
          ],
        ),
        body:WillPopScope(child:  PageView(
          onPageChanged: (val) {
            setState(() {
              currentindex = val;
            });
          },
          children: [OrdersWait(), OrdersPrepare(), OrdersDone()],
          controller: _controller,
        ), onWillPop: (){
          Navigator.of(context).pushNamed("home") ; 
          return ; 
        }),
      ),
    );
  }
}
