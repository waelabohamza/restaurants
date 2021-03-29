import 'package:flutter/material.dart';
import 'package:restaurants/pages/delivery/adddelivery.dart';
import 'package:restaurants/pages/money/money.dart';
import 'package:restaurants/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final balance ; 
  MyDrawer({Key key , this.balance}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var username;
  var email;
  var resid;
  bool isSignIn = false;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString("username");
    email = preferences.getString("email");

    if (username != null) {
      setState(() {
        resid = preferences.getString("id");
        username = preferences.getString("username");
        email = preferences.getString("email");
        isSignIn = true;
      });
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: isSignIn ? Text(email) : Text(""),
          accountName: isSignIn ? Text(username) : Text(""),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),
        ListTile(
          title: Text(
            "الصفحة الرئيسية",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          leading: Icon(
            Icons.home,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('home');
          },
        ),
        ListTile(
          title: Text("الوجبات",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.fastfood,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed("items", arguments: {"resid": resid});
          },
        ),
        ListTile(
          title: Text("اضافة وجبة",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.add_box,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).pushNamed("additems");
          },
        ),
        ListTile(
          title: Text("كشف الحساب",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.monetization_on,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Bill(balance: widget.balance) ; 
            })) ; 
          },
        ),
        ListTile(
          title: Text("اضافة عامل توصيل",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.add_box,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddDelivery(resid: resid);
            }));
          },
        ),
        Divider(color: Colors.blue),
        ListTile(
          title: Text(" حول التطبيق  ",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.info,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {},
        ),
        ListTile(
          title: Text("الاعدادات",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.settings,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () {
            return Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return Settings(resid: resid);
            }));
          },
        ),
        ListTile(
          title: Text("تسجيل الخروج",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.blue,
            size: 25,
          ),
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("username");
            preferences.remove("email");
            preferences.remove("id");
            Navigator.of(context).pushNamed("login");
          },
        )
      ],
    ));
  }
}
