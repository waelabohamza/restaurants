import 'dart:ui';
import 'package:jiffy/jiffy.dart';
import "package:flutter/material.dart";
import 'package:restaurants/component/crud.dart';
// import 'package:restaurants/component/myappbar.dart';
import 'package:restaurants/main.dart';

class Bill extends StatefulWidget {
  final balance ; 
  Bill({Key key  , this.balance}) : super(key: key);

  @override
  _BillState createState() => _BillState();
}

class _BillState extends State<Bill> {
  Crud crud = new Crud();
  Map data;
  String datebetween = "all";
  setLocal(lang) async {
    await Jiffy.locale(lang);
  }

  @override
  void initState() {
    super.initState();
    setLocal("en");
    data = {"userid": sharedPrefs.getString("id"), "datebetween": datebetween};
  }

  @override
  void dispose() {
    setLocal("ar");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("كشف الحساب"),
          ),
          body: Container(
              child: ListView(children: [
            // MyAppBar(currentpage: "bill", titlepage: "كشف الحساب"),
            Container(
                child: Card(
                    child: Column(children: [
              buildCardTopRow("نوع الحساب", "جاري"),
              Divider(),
              buildCardTopRow(
                  "الرصيد الكلي", " ${widget.balance} KWD"),
              Divider(),
              buildCardTopRow(
                  "الرصيد المتاح", " ${widget.balance} KWD "),
            ]))),
            buildContainerDay(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "التاريخ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Spacer(),
                  Text("التفاصيل",
                      style: Theme.of(context).textTheme.bodyText1),
                  Spacer(),
                  Text("السعر", style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
            ),
            Card(
              child: FutureBuilder(
                future: crud.writeData("bill", data),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                     
                     if(snapshot.data[0] == "faild") return Text("لا يوجد اي عملية حاليا ")  ;

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return buildCardBottomRow(
                              snapshot.data[i]['bill_date'],
                              snapshot.data[i]['bill_price'],
                              snapshot.data[i]['bill_title'],
                              snapshot.data[i]['bill_body'],
                              snapshot.data[i]['bill_type']);
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                  //  ,
                },
              ),
            ),
          ])),
        ));
  }

  Container buildContainerDay() {
    TextStyle daystyle = TextStyle(
        color: Colors.brown, fontFamily: "Cairo", fontWeight: FontWeight.bold);

    return Container(
        child: Card(
            child: Container(
      padding: EdgeInsets.all(10),
      child: Row(children: [
        Spacer(
          flex: 1,
        ),
        InkWell(
          onTap: () {
            setState(() {
              data = {
                "userid": sharedPrefs.getString("id"),
                "datebetween": "day"
              };
            });
          },
          child: Column(
            children: [
              Text("1", style: daystyle),
              Text(
                "ايام",
                style: daystyle,
              )
            ],
          ),
        ),
        Spacer(
          flex: 3,
        ),
        InkWell(
          onTap: () {
            setState(() {
              data = {
                "userid": sharedPrefs.getString("id"),
                "datebetween": "week"
              };
            });
          },
          child: Column(
            children: [
              Text("7", style: daystyle),
              Text(
                "ايام",
                style: daystyle,
              )
            ],
          ),
        ),
        Spacer(
          flex: 3,
        ),
        InkWell(
          onTap: () {
            setState(() {
              data = {
                "userid": sharedPrefs.getString("id"),
                "datebetween": "month"
              };
            });
          },
          child: Column(
            children: [
              Text("30", style: daystyle),
              Text("ايام", style: daystyle)
            ],
          ),
        ),
        Spacer(flex: 3),
        InkWell(
          onTap: () {
            setState(() {
              data = {
                "userid": sharedPrefs.getString("id"),
                "datebetween": "threemonth"
              };
            });
          },
          child: Column(
            children: [
              Text("90", style: daystyle),
              Text("ايام", style: daystyle)
            ],
          ),
        ),
        Spacer(flex: 3),
        InkWell(
          onTap: () {
            setState(() {
              data = {
                "userid": sharedPrefs.getString("id"),
                "datebetween": "year"
              };
            });
          },
          child: Column(
            children: [
              Text("360", style: daystyle),
              Text("ايام", style: daystyle)
            ],
          ),
        ),
        Spacer(flex: 3),
        InkWell(
          onTap: () {
            setState(() {
              data = {
                "userid": sharedPrefs.getString("id"),
                "datebetween": "all"
              };
            });
          },
          child: Column(
            children: [
              Text("كل", style: daystyle),
              Text("ايام", style: daystyle)
            ],
          ),
        ),
        Spacer(
          flex: 1,
        )
      ]),
    )));
  }

  Row buildCardTopRow(String textmaster, String textbranch) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$textmaster", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              "$textbranch",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget buildCardBottomRow(String textmaster, String textbranch, String title,
      String body, String type) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                child: Text(
                  "${Jiffy(textmaster).format("yyyy-MM-d")}",
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text("  $textbranch  KWD",
                      style: TextStyle(
                          color: type == "0" ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title"),
                  Text("$body"),
                ],
              ),
            ),
          ),
          // Divider()
        ]);
  }
}
