import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:restaurants/component/alert.dart';
import 'dart:io';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/component/getnotify.dart';
import 'package:restaurants/pages/sign/signuptwo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../component/alert.dart' as alert;
import 'package:restaurants/component/valid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
 

class _LoginState extends State<Login> {
  Crud crud = new Crud();

  String tokenres ; 
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  File filelogo;
  // File myfilelogo;
  File filelisence;
  // File myfilelicence;

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Start Form Controller

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  GlobalKey<FormState> formstatesignin = new GlobalKey<FormState>();
  GlobalKey<FormState> formstatesignup = new GlobalKey<FormState>();

  savePref(String username, String email, String id,  String phone  , String image ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", id);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("phone", phone);
    preferences.setString("image", image);
    print(preferences.getString("username"));
    print(preferences.getString("email"));
    print(preferences.getString("id"));
  }

  var idres;

  // Start Uploaded Images

  void _choosegallery(String type) async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery , imageQuality: 50 ,maxHeight: 400 , maxWidth: 400);
    // For Show Image Direct in Page Current witout Reload Page
    if (type == "logo") {
      if (myfile != null) {
        setState(() {
          filelogo = File(myfile.path);
        });
      }
    }
    if (type == "lisence") {
      if (myfile != null) {
        setState(() {
          filelisence = File(myfile.path);
        });
      }
    }
  }

  void _choosecamera(String type) async {
    final myfile = await ImagePicker().getImage(source: ImageSource.camera , imageQuality: 50 ,maxHeight: 400 , maxWidth: 400);
    // For Show Image Direct in Page Current witout Reload Page
    if (type == "logo") {
      if (myfile != null) {
        setState(() {
          filelogo = File(myfile.path);
        });
      }
    }
    if (type == "lisence") {
      if (myfile != null) {
        setState(() {
          filelisence = File(myfile.path);
        });
      }
    }
  }

 

  signin() async {
    var formdata = formstatesignin.currentState;
    if (formdata.validate()) {
      formdata.save();
      showLoading(context);
      var data ; 
      if (tokenres == null) {
        data = {"email": email.text, "password": password.text };
      }else {
        data = {"email": email.text, "password": password.text , "token" : tokenres  };
      }
      var responsebody = await crud.writeData("login", data);
      if (responsebody['status'] == "success") {
        savePref(responsebody['message']['res_name'], responsebody['message']['res_email'],
            responsebody['message']['res_id'] , responsebody['message']['res_phone'] , responsebody['message']['res_image']);
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        print("login faild");
        Navigator.of(context).pop() ; 
        showdialogall(context, "خطأ", "البريد الالكتروني او كلمة المرور خاطئة");
      }
    } else {
      print("not valid");
    }
  }

  signup() async {
    if (filelogo == null)
      return alert.showdialogall(context, "خطأ", "يجب اختيار شعار للمطعم ");
    if (filelisence == null)
      return alert.showdialogall(context, "خطأ", "يجب رفع صورة الرخصة");
    // Var For Images
    var formdata = formstatesignup.currentState;
    if (formdata.validate()) {
      formdata.save();
      showLoading(context);
      var responsebody = await crud.signUpRestarants(username.text,
          password.text, email.text, phone.text, filelogo, filelisence);
      if (responsebody['status'] == "success") {
        print("yes success");
        var ressignemail = responsebody['res_email'];
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return SignUpTwo(
            resemail: ressignemail,
          );
        }));
      } else {
        print(responsebody['status']);
        Navigator.of(context).pop();
        showdialogall(context, "خطأ", " البريد الالكتروني موجود سابقا ");
      }
    } else {
      print("not valid");
    }
  }

  TapGestureRecognizer _changesign;
  bool showsignin = true;

    getmytoken() async {
         tokenres =  await  getTokenDevice() ; 
         if (tokenres != null) return  ; 
         tokenres =  await  getTokenDevice() ; 
    } 

  @override
  void initState() {
     getmytoken()  ; 
    _changesign = new TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showsignin = !showsignin;
          print(showsignin);
        });
      };
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(height: double.infinity, width: double.infinity),
            buildPositionedtop(mdw),
            buildPositionedBottom(mdw),
            Container(
                height: 1000,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 30),
                              child: Text(
                                showsignin ? "تسجيل الدخول " : "انشاء حساب",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: showsignin ? 22 : 25),
                              ))),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      buildContaineraAvatar(mdw),
                      showsignin
                          ? buildFormBoxSignIn(mdw)
                          : buildFormBoxSignUp(mdw),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              showsignin
                                  ? InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "  ? هل نسيت كلمة المرور",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ))
                                  : SizedBox(),
                              !showsignin
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text(
                                            "صورة للرخصة",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          color: filelisence == null
                                              ? Colors.red
                                              : Colors.blue,
                                          onPressed: () {
                                            return showbottommenu("lisence");
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text(
                                            "صورة للشعار",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          color: filelogo == null
                                              ? Colors.red
                                              : Colors.blue,
                                          onPressed: () {
                                            return showbottommenu("logo");
                                          },
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(height: showsignin ? 24 : 5),
                              RaisedButton(
                                color:
                                    showsignin ? Colors.blue : Colors.grey[700],
                                elevation: 10,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                onPressed: showsignin ? signin : signup,
                                // onPressed: () => Navigator.of(context).pushNamed("home"),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      showsignin
                                          ? "تسجيل الدخول"
                                          : "انشاء حساب",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 4),
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Cairo'),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: showsignin
                                                  ? "في حال ليس لديك حساب يمكنك "
                                                  : "اذا كان لديك حساب يمكنك"),
                                          TextSpan(
                                              recognizer: _changesign,
                                              text: showsignin
                                                  ? " انشاء حساب من هنا  "
                                                  : " تسجيل الدخول من هنا  ",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w700))
                                        ]),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                             
                            ],
                          )),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Center buildFormBoxSignIn(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        margin: EdgeInsets.only(top: 40),
        height: 250,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
            autovalidate: true,
            key: formstatesignin,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "البريد الالكتروني",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل البريد الالكتروني", false, email, "email"),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, "password"),
                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Center buildFormBoxSignUp(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutBack,
        margin: EdgeInsets.only(top: 20),
        height: 403,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
            autovalidate: true,
            key: formstatesignup,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "اسم المستخدم",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل اسم المستخدم", false, username, "username"),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, "password"),
                    // Start Text password CONFIRM
                    Text("رقم الهاتف",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل رقم الهاتف", false , phone, "phone"),
                    // Start Text EMAIL
                    Text("البريد الالكتروني",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل البريد الالكتروني هنا ", false, email, "email"),
                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  TextFormField buildTextFormFieldAll(
      String myhinttext, bool pass, TextEditingController myController, type) {
    return TextFormField(
      controller: myController,
      obscureText: pass,
      validator: (val) {
        if (type == "username") {
          return validInput(val, 4, 30, "يكون اسم المستخدم");
        }
        if (type == "password") {
          return validInput(val, 4, 30, "تكون كلمة المرور");
        }
        if (type == "email") {
          return validInput(val, 4, 40, " يكون البريد الالكتروني ", "email");
        }if (type == "phone") {
          return validInput(val, 4, 30, " يكون رقم الهاتف ", "number");
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: myhinttext,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[500], style: BorderStyle.solid, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue, style: BorderStyle.solid, width: 1))),
    );
  }

  AnimatedContainer buildContaineraAvatar(double mdw) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: showsignin ? Colors.yellow : Colors.grey[700],
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0.1)
          ]),
      child: InkWell(
        onTap: () {
          setState(() {
            showsignin = !showsignin;
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 25,
                right: 25,
                child:
                    Icon(Icons.person_outline, size: 50, color: Colors.white)),
            Positioned(
                top: 35,
                left: 60,
                child: Icon(Icons.arrow_back, size: 30, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Positioned buildPositionedtop(double mdw) {
    return Positioned(
        child: Transform.scale(
      scale: 1.3,
      child: Transform.translate(
        offset: Offset(0, -mdw / 1.7),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: showsignin ? Colors.grey[800] : Colors.blue)),
      ),
    ));
  }

  Positioned buildPositionedBottom(double mdw) {
    return Positioned(
        top: 300,
        right: mdw / 1.5,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: showsignin
                    ? Colors.blue[800].withOpacity(0.2)
                    : Colors.grey[800].withOpacity(0.3))));
  }

  showbottommenu(String type) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "Chooser Photo",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  onTap: () {
                    if (type == "logo") {
                      _choosecamera("logo");
                    }
                    if (type == "lisence") {
                      _choosecamera("lisence");
                    }
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  title: Text("   Take Photo", style: TextStyle(fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    if (type == "logo") {
                      _choosegallery("logo");
                    }
                    if (type == "lisence") {
                      _choosegallery("lisence");
                    }
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.image,
                    size: 40,
                  ),
                  title: Text("Upload From Gallery",
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          );
        });
  }
}
