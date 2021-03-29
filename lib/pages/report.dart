import 'package:flutter/material.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/main.dart';

class Report extends StatefulWidget {
  Report({Key key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var databetween = "year";
  Crud crud = new Crud();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[850],
            title: Text('التقارير'),
          ),
          body: Container(
              child: ListView(
            children: [
              Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
                  child: Card(
                    shape: Border.all(color: Colors.grey[600]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                databetween = "day";
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("يوم"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                databetween = "week";
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("اسبوع"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                                 setState(() {
                                databetween = "month";
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("شهر"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                               setState(() {
                                databetween = "yaer";
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("سنة"),
                            ),
                          ),
                          //  Expanded(child: Text("كل الاوقات")) ,
                        ],
                      ),
                    ),
                  )),
              FutureBuilder(
                future: crud.writeData("report", {
                  "resid": sharedPrefs.getString("id"),
                  "grossing": "yes",
                  "datebetween": databetween
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data[0] == "faild") return SizedBox() ; 

                    return buildBodyReport(
                        "الوجبات الاكثر ربحا", snapshot.data, "grossing");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: crud.writeData("report", {
                  "resid": sharedPrefs.getString("id"),
                  "datebetween": databetween
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    print("==================================") ; 
                    print(snapshot.data) ; 
                    print("==================================") ; 
                    
                    if (snapshot.data[0] == "faild") return Center(child: Text("لا يوجد طلبات في هذا الوقت")) ; 
                    return buildBodyReport(
                        "الوجبات الاكثر مبيعا", snapshot.data, "selling");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: crud.writeData(
                    "totalorders", {"resid": sharedPrefs.getString("id"),
                  "datebetween": databetween}),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {

                    return buildNumberReport(
                        "الطلبات الكلية", "${snapshot.data['count']}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          )),
        ));
  }

  buildBodyReport(String title, report, String type) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Card(
            shape: Border.all(color: Colors.grey[600]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Text(
                      "$title",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 150,
                    child: Divider(
                      color: Colors.grey,
                    )),
                Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Text(
                          type == "selling"
                              ? "${report[0]['item_name']} "
                              : "${report[0]['item_name']}  ",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
                        Text(
                          type == "selling"
                              ? " ${report[0]['count_items']} تم البيع"
                              : "${double.parse(report[0]['totalprice']).toStringAsFixed(3)} KWD",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.grey,
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: report.length,
                          itemBuilder: (context, i) {
                            return i != 0
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Text("$i - ${report[i]['item_name']}"),
                                        Spacer(),
                                        Text(
                                          type == "selling"
                                              ? "${report[i]['count_items']} تم البيع"
                                              : "${double.parse(report[i]['totalprice']).toStringAsFixed(3)} KWD",
                                        )
                                      ],
                                    ))
                                : SizedBox();
                          })
                    ],
                  ),
                )
              ],
            )));
  }

  buildNumberReport(String title, String number) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Card(
            shape: Border.all(color: Colors.grey[600]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Text(
                      "$title",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 120,
                    child: Divider(
                      color: Colors.grey,
                    )),
                Container(
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "$number",
                    style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                ),
              ],
            )));
  }
}
/*

SELECT DISTINCT(orders_details.details_item) 
, SUM(orders_details.details_quantity )
, items.item_price
, items.item_name

FROM orders_details 

INNER JOIN items ON orders_details.details_item = items.item_id

SELECT DISTINCT(orders_details.details_item) 
, items.item_price
, items.item_name , 
items.item_id

FROM orders_details 

INNER JOIN items ON orders_details.details_item = items.item_id

*/
