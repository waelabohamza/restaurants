import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:restaurants/component/alert.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/component/valid.dart';
import 'package:restaurants/pages/sign/signupfour.dart';

class SignUpThree extends StatefulWidget {
  final resemail;
  final country;
  final area;
  final street;

  SignUpThree({Key key, this.resemail, this.country, this.area, this.street})
      : super(key: key);

  @override
  _SignUpThreeState createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {
  Crud crud = new Crud();

  var country,
      area,
      street,
      timedelivery,
      pricedelivery,
      description,
      restype,
      nameen;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  String _catname = null;
  List<dynamic> _datadropdown = List();

  signUpThree() async {
    if (_catname == null)
      return showdialogall(context, "خطا", "يجب اختيار نوع المطعم");
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      Map data = {
        "name_en": nameen,
        "resemail": widget.resemail.toString(),
        "country": country,
        "area": area,
        "street": street,
        "timedelivery": timedelivery.toString(),
        "pricedelivery": pricedelivery.toString(),
        "description": description.toString(),
        "type": _catname.toString()
      };
      var responsebody = await crud.writeData("signupthree", data);
      if (responsebody['status'] == "success") {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return SignUpFour(email: widget.resemail);
        }));
      }
    } else {
      print("not vaild");
      print(street);
    }
  }

  void getCatName() async {
    String url = "catsres";
    var listData = await crud.readData(url);
    for (int i = 0; i < listData.length; i++)
      if (this.mounted) {
        setState(() {
          _datadropdown.add(listData[i]['catsres_name']);
        });
      }
    // print("data : $listData");
  }

  @override
  void initState() {
    getCatName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('اعدادات المطعم'),
          ),
          body: Container(
            child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    buildTextForm("", "اسم المطعم باللغة الانكليزية", Icon(Icons.title), "nameen"),
                    buildTextForm(
                        widget.country, "البلد", Icon(Icons.flag), "country"),
                    buildTextForm(widget.area, "المنطقة",
                        Icon(Icons.location_city), "area"),
                    buildTextForm(widget.street, "الشارع",
                        Icon(Icons.streetview), "street"),
                    buildTextForm("30", "وقت التوصيل",
                        Icon(Icons.time_to_leave), "timedelivery"),
                    buildTextForm("0", "سعر التوصيل اذا كان مجاني اتركه 0",
                        Icon(Icons.monetization_on), "pricedelivery"),
                    buildTextForm(" ", " وصف للمطعم ", Icon(Icons.description),
                        "description"),
                    Container(
                        color: Colors.white,
                        child: DropdownSearch(
                          backgroundColor: Colors.white,
                          items: _datadropdown,
                          label: "اختر هنا نوع المطعم",
                          onChanged: (val) {
                            _catname = val;
                            print(_catname);
                          },
                        )),
                    Container(
                      child: MaterialButton(
                        onPressed: () {
                          return signUpThree();
                        },
                        child: Text(
                          "تم",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        color: Colors.red,
                      ),
                    )
                  ],
                )),
          ),
        ));
  }

  TextFormField buildTextForm(initialvalue, String labeltext, Icon icon, type) {
    return TextFormField(
      onSaved: (val) {
        if (type == "country") {
          country = val;
        }
        if (type == "nameen") {
          nameen = val;
        }
        if (type == "area") {
          area = val;
        }
        if (type == "street") {
          street = val;
        }
        if (type == "timedelivery") {
          timedelivery = val;
        }
        if (type == "pricedelivery") {
          pricedelivery = val;
        }
        if (type == "description") {
          description = val;
        }
      },
      initialValue: initialvalue,
      validator: (val) {
        if (type == "country") {
          return validInput(val, 4, 20, "يكون اسم البلد");
        }
        if (type == "area") {
          return validInput(val, 4, 20, "يكون  اسم المنطقة");
        }
        if (type == "nameen") {
          return validInput(val, 4, 20, "يكون  اسم المطعم");
        }
        if (type == "street") {
          return validInput(val, 4, 20, "يكون اسم الشارع");
        }
        if (type == "timedelivery") {
          return validInput(val, 1, 20, " يكون زمن التوصيل ", "number");
        }
        if (type == "pricedelivery") {
          return validInput(val, 0, 20, " يكون سعر التوصيل ", "number");
        }
        if (type == "description") {
          return validInput(val, 10, 100, " يكون الوصف  ");
        }
      },
      keyboardType: type == "pricedelivery" || type == "timedelivery"
          ? TextInputType.number
          : TextInputType.text,
      minLines: 1,
      maxLines: type == "description" ? 3 : 1,
      decoration: InputDecoration(
          labelText: labeltext,
          //  labelStyle: TextStyle(color: Colors.red),
          prefixIcon: icon,
          filled: true,
          fillColor: Colors.white),
    );
  }
}
