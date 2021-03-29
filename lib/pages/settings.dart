import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/component/valid.dart';

class Settings extends StatefulWidget {
  final resid;

  Settings({Key key, this.resid}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  var description,
      restype,
      password,
      country,
      area,
      street,
      timedelivery,
      pricedelivery;

  String _catname = null;
  List<dynamic> _datadropdown = List();

  Crud crud = new Crud();

  List restaurant = new List();

  bool loading = true;

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

  getRestaurant() async {
    setState(() {
      loading = true;
    });

    var responsebody =
        await crud.readDataWhere("restaurant", widget.resid.toString());
    restaurant.add(responsebody);

    print(restaurant);

    setState(() {
      loading = false;
    });
  }

  updateSettings() async {
    var formdata = formstate.currentState;

    if (formdata.validate()) {
      formdata.save();
      Map data = {
        "resid": widget.resid.toString(),
        "country": country,
        "area": area,
        "street": street,
        "timedelivery": timedelivery.toString(),
        "pricedelivery": pricedelivery.toString(),
        "description": description.toString(),
        "type": _catname.toString()
      };
      var responsebody = await crud.writeData("settingsrestauratnt", data);
      Navigator.of(context).pushReplacementNamed("home");
    }
  }

  @override
  void initState() {
    print("===========================");
    print(widget.resid);
    print("===========================");
    getRestaurant();
    getCatName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: Scaffold(
            appBar: AppBar(
              title: Text('البروفاييل'),
            ),
            body: ListView(
              children: <Widget>[
                loading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: formstate,
                        child: Column(
                          children: [
                            buildTextForm(restaurant[0]['res_country'], "البلد",
                                Icon(Icons.flag), "country"),
                            buildTextForm(restaurant[0]['res_area'], "المنطقة",
                                Icon(Icons.location_city), "area"),
                            buildTextForm(restaurant[0]['res_street'], "الشارع",
                                Icon(Icons.streetview), "street"),
                            buildTextForm(
                                restaurant[0]['res_time_delivery'],
                                "وقت التوصيل",
                                Icon(Icons.time_to_leave),
                                "timedelivery"),
                            buildTextForm(
                                restaurant[0]['res_price_delivery'],
                                "سعر التوصيل اذا كان مجاني اتركه 0",
                                Icon(Icons.monetization_on),
                                "pricedelivery"),
                            buildTextForm(
                                restaurant[0]['res_description'],
                                " وصف للمطعم ",
                                Icon(Icons.description),
                                "description"),
                            // buildTextForm(
                            //     restaurant[0]['res_type'],
                            //     " نوع المطعم بما لايتجاوز 20 حرف ",
                            //     Icon(Icons.category),
                            //     "restype"),
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
                                  selectedItem: restaurant[0]['catsres_name'],
                                )),
                            SizedBox(height: 20),
                            Container(
                              child: MaterialButton(
                                onPressed: () {
                                  return updateSettings();
                                },
                                child: Text(
                                  "تعديل البيانات",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ));
  }

  TextFormField buildTextForm(initialvalue, String labeltext, Icon icon, type) {
    return TextFormField(
      onSaved: (val) {
        if (type == "country") {
          country = val;
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
        if (type == "restype") {
          restype = val;
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
        if (type == "restype") {
          return validInput(val, 5, 30, " يكون نوع المطعم ");
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
