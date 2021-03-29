import 'dart:convert';
import 'dart:io';
// import 'package:admin/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// My Import
import 'package:restaurants/component/alert.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/component/valid.dart';

class AddDelivery extends StatefulWidget {
  final resid ; 
  AddDelivery({Key key  ,this.resid}) : super(key: key);

  @override
  _AddDeliveryState createState() => _AddDeliveryState();
}

class _AddDeliveryState extends State<AddDelivery> {
  File file;
  File myfile;

  bool loading = false;

  void _chooseGallery() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery , imageQuality: 50 ,maxHeight: 400 , maxWidth: 400);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  void _chooseCamera() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.camera , imageQuality: 50 ,maxHeight: 400 , maxWidth: 400);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  Crud crud = new Crud();

  var username, password, email , phone  ,deliveryres;

  GlobalKey<FormState> settings = new GlobalKey<FormState>();

  addDeilvery() async {
    if (file == null) return showdialogall(context, "خطأ", "يجب اضافة صورة ");
    var formdata = settings.currentState;
    if (formdata.validate()) {
      formdata.save();

      setState(() {
        loading = true;
      });
      if (loading == true) {
        showLoading(context);
      }

      var responsebody = await crud.addUsers(email, password, username, phone , widget.resid  ,file);
      // var responsebody = await crud.checkProblem(email, password, username, phone );

      setState(() {
        loading = false;
      });
      if (responsebody['status'] == "success") {
        print("yes success");
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        print(responsebody['status']);
        Navigator.of(context).pop();
        showdialogall(context, "خطأ", " البريد الالكتروني موجود سابقا ");
      }
    } else {
      print("not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => Common() , child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text('اضافة عامل التوصيل'),
            ),
            body: ListView(
              children: <Widget>[
                Form(
                    key: settings,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          onSaved: (val) {
                            username = val;
                          },
                          validator: (val) {
                            return validInput(val, 4, 20, "يكون اسم المستخدم");
                          },
                          decoration: InputDecoration(
                              labelText: "الاسم",
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.person)),
                        ),
                        Consumer<Common>(
                          builder: (context, common, child) {
                            return TextFormField(
                              obscureText: common.showpass,
                              validator: (val) {
                                return validInput(
                                    val, 4, 20, "تكون كلمة المرور");
                              },
                              onSaved: (val) {
                                password = val;
                              },
                              decoration: InputDecoration(
                                  labelText: " كلمة المرور ",
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      common.changeShowPass();
                                    },
                                  )),
                            );
                          },
                        ),
                        TextFormField(
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (val) {
                            return validInput(val, 4, 40,
                                " يكون البريد الالكتروني ", "email");
                          },
                          decoration: InputDecoration(
                              labelText: "البريد الالكتروني",
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.email)),
                        ),
                        TextFormField(
                          onSaved: (val) {
                            phone = val;
                          },
                          validator: (val) {
                            return validInput(val, 4, 20,
                                " يكون رقم الهاتف ", "phone");
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "رقم هاتف",
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.phone)),
                        ),
                        RaisedButton(
                          color: file == null ? Colors.red : Colors.green,
                          child: Text(
                            "اضافة صورة",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showbottommenu(context);
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "اضافة",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            addDeilvery();
                          },
                        )
                      ],
                    ))
              ],
            ))),);
  }

  showbottommenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Directionality(textDirection: TextDirection.rtl, child: Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "اختيار صورة",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  onTap: () {
                    _chooseCamera();
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  title: Text("من الكاميرا", style: TextStyle(fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    _chooseGallery();
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.image,
                    size: 40,
                  ),
                  title: Text("من الاستديو",
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ));
        });
  }
}
class Common with ChangeNotifier {
  bool showpass = true ; 
  changeShowPass(){
    showpass =  !showpass ; 
    notifyListeners() ; 
  }
}