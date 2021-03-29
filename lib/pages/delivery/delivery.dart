import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/pages/delivery/adddelivery.dart';
import 'package:restaurants/pages/delivery/deliverylist.dart';


class Delivery extends StatefulWidget {
  final resid ; 
  Delivery({Key key , this.resid}) : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  Crud crud = new Crud();
  deleteUsers(id, image) async {
    var data = {"userid": id, "userimage": image};
    await crud.writeData("deleteusers", data);
  }
  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('الاعضاء'),
             actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                  //   showSearch(
                  //       context: context,
                  //       delegate: DataSearch(type: "users"   , mdw : mdw ));
                  })
            ]
          ),
          floatingActionButton: Container(
              padding: EdgeInsets.only(left: mdw - 100),
              child: Container(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return AddDelivery(resid: widget.resid) ; 
                      }));
                    },
                    child: Icon(
                      Icons.add,
                      size: 40,
                    ),
                    backgroundColor: Colors.red,
                  ))),
          body: WillPopScope(
              child: FutureBuilder(
                future: crud.readDataWhere("delivery" , widget.resid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data[0] == "faild") {
                      return Center(child: Text("لا يوجد عمال توصيل لهذا المطعم"  , style: TextStyle(color: Colors.red , fontSize: 20),));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            await deleteUsers(snapshot.data[i]['user_id'],
                                snapshot.data[i]['user_image']);
                            setState(() {
                              snapshot.data.removeAt(i);
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            child: Center(
                                child: Text("حذف نهائي",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white))),
                          ),
                          direction: DismissDirection.startToEnd,
                          child: DeliveryList(listusers: snapshot.data[i]),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              onWillPop: () {
                Navigator.of(context).pushReplacementNamed("home");
              }),
        ));
  }
}
