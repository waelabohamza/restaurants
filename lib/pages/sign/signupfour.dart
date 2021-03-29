import 'package:flutter/material.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/pages/sign/signupfive.dart';

class SignUpFour extends StatefulWidget {
  final email;
  SignUpFour({Key key, this.email}) : super(key: key);

  @override
  _SignUpFourState createState() => _SignUpFourState();
}

class _SignUpFourState extends State<SignUpFour> {
  Crud crud = new Crud();

  bool door = false;
  bool cashier = false;
  bool delivery = true;
  bool table = false;
  bool tableqrcode = false;
  bool drivethru = false;

  List deliveryways = ["4"];

  addDeliveryWay() async {
    Map data = {"deliveryways": deliveryways, "email": widget.email};
    var responsebody = await crud.addDeliveryWays(data)  ; 
    if (responsebody['status'] == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return SignUpFive() ; 
      })) ; 
    }
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("اختر طرق التوصيل"),
          ),
          body: Container(
            child: Column(
              children: [
                checkbox("الاستلام عند الباب", door, "door", mdw),
                checkbox(" الاستلام من الكاشير سفري", cashier, "cashier", mdw),
                checkbox("الاستلام عند الشباك", drivethru, "drivethru", mdw),
                checkbox("الاستلام من الكاشير والجلوس على الطاولة ", table,
                    "table", mdw),
                checkbox("الطلب على الطاولة من خلال qrcode", tableqrcode,
                    "tableqrcode", mdw),
                Container(
                  width: 200,
                  child: RaisedButton(
                    onPressed: addDeliveryWay,
                    child: Text(
                      "تم بنجاح",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: Colors.red,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget checkbox(String title, bool boolValue, String type, mdw) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: mdw - 20,
            child: CheckboxListTile(
              title: Text(
                "$title",
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              value: boolValue,
              onChanged: (bool value) {
                /// manage the state of each value
                setState(() {
                  switch (type) {
                    case "door":
                      door = value;
                      value == true
                          ? deliveryways.add("3")
                          : deliveryways.remove("3");
                      break;
                    case "drivethru":
                      drivethru = value;
                      value == true
                          ? deliveryways.add("1")
                          : deliveryways.remove("1");

                      break;
                    case "cashier":
                      cashier = value;
                      value == true
                          ? deliveryways.add("2")
                          : deliveryways.remove("2");

                      break;
                    case "table":
                      table = value;
                      value == true
                          ? deliveryways.add("5")
                          : deliveryways.remove("5");

                      break;
                    case "tableqrcode":
                      tableqrcode = value;
                      value == true
                          ? deliveryways.add("6")
                          : deliveryways.remove("6");

                      break;
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
