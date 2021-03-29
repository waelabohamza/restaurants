import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:restaurants/component/alert.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/main.dart';

// My Import

class OrdersWait extends StatefulWidget {
  OrdersWait({Key key}) : super(key: key);
  @override
  _OrdersWaitState createState() => _OrdersWaitState();
}

class _OrdersWaitState extends State<OrdersWait> {
  var resid;
  var data;
  Crud crud = new Crud();
  setLocal() async {
    await Jiffy.locale("ar");
  }

  getidres() {
    resid = sharedPrefs.getString("id");
    data = {"resid": resid, "typeorder": "wait"};
  }

  @override
  void initState() {
    setLocal();
    getidres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: resid == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: crud.writeData("orders", data),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data[0] == "faild") {
                          return Center(
                              child: Text(
                            "لا يوجد اي طلب في هذا المطعم ",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListOrders(
                              orders: snapshot.data[index],
                              context: context,
                              crud: crud,
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  )));
  }
}

class ListOrders extends StatelessWidget {
  final orders;
  final crud;
  final context;
  const ListOrders({Key key, this.orders, this.crud, this.context})
      : super(key: key);

  approveDelivery() async {
    showLoading(context);
    Map data2 = {
      "ordersid": orders['orders_id'],
      "resid": orders['orders_res'],
      "userid": orders['orders_users'],
      "type": orders['orders_type'] , 
      "price" : orders['orders_total']
    };
    var responsebody = await crud.writeData("approveorders", data2);
    if (responsebody['status'] == "success") {
      // Navigator.of(context).pop() ;
      Navigator.of(context).pushNamed("orders");
    }
  }

  denyOrders() async {
    showLoading(context);
    Map data2 = {
      "ordersid": orders['orders_id'],
      "resid": orders['orders_res'],
      "userid": orders['orders_users'],
      "price" : orders['orders_total']
    };
    var responsebody = await crud.writeData("denyorders", data2);
    if (responsebody['status'] == "success") {
      // Navigator.of(context).pop() ;
      Navigator.of(context).pushNamed("orders");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Container(
              margin: EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "معرف الطلبية : ${orders['orders_id']}",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "اسم الزبون : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['username']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "هاتف الزبون  : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['user_phone']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "نوع الطلب  : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['orders_type']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "سعر    : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['orders_total']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])),
                ],
              ),
            ),
            trailing: Container(
                margin: EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${Jiffy(orders['orders_date']).fromNow()}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
          ),
          Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            child: Row(
              children: [
                Text(
                  "الوجبة",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Expanded(child: Container()),
                Text("الكميه",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          FutureBuilder(
            future: Crud().readDataWhere("ordersdetails", orders['orders_id']),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(snapshot.data[i]['item_name']),
                                Expanded(child: Container()),
                                Text(snapshot.data[i]['details_quantity']),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          Container(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
            child: Row(
              children: [
                Text(
                  "بانتظار الموافقة ",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  children: [
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "رفض",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          )),
                      onTap: denyOrders,
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "موافقة",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          )),
                      onTap: approveDelivery,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
