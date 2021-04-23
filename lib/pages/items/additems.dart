import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants/component/valid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
// import "package:searchable_dropdown/searchable_dropdown.dart";
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:restaurants/component/alert.dart';
import 'package:restaurants/component/mydrawer.dart';
import 'package:restaurants/component/crud.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Crud crud = new Crud();
  File file;
  File myfile;
  GlobalKey<FormState> formdata = new GlobalKey<FormState>();
  var itemname;
  var itemprice;
  var itemsize;
  var itemdesc;
  var itemnameen;
  bool loading;

  String _catname = null;
  List<dynamic> _datadropdown = List();
  void _choosegallery() async {
    final myfile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 1000,
        maxWidth: 1000);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  void _choosecamera() async {
    final myfile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 1000,
        maxWidth: 1000);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  var itemres;

  addItem() async {
    // assert(_catname != null) ;
    var formstate = formdata.currentState;
    if (formstate.validate()) {
      formstate.save();
      if (file == null) return showdialogall(context, "خطأ", "يجب اضافة صورة ");
      if (_catname == null)
        return showdialogall(context, "خطأ", "يجب تحديد القسم");
      showLoading(context);
      await crud.addItems(
          itemname, itemnameen, itemprice, _catname, itemres, itemdesc, file);
      // var response = await http.post(url, body: data);
      // var responsebody = jsonDecode(response.body);
      setState(() {
        loading = false;
      });

      // print(response.body);

      Navigator.of(context).pushReplacementNamed("home");
    } else {
      print("Not Valid");
    }
  }

  Future getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        itemres = prefs.getString('id');
      });
    }
    // print(itemres);
  }

  // Start DropDown Menu

  void getCatName() async {
    String url = "categories";

    var listData = await crud.readData(url);
    for (int i = 0; i < listData.length; i++)
      if (this.mounted) {
        setState(() {
          _datadropdown.add(listData[i]['cat_name']);
        });
      }
    print(_datadropdown);

    // print("data : $listData");
  }

  // End
  @override
  void initState() {
    getprefs();
    getCatName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text('اضافة وجبة'),
            ),
            // drawer: MyDrawer(),
            body: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Form(
                    key: formdata,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          onSaved: (val) {
                            itemname = val;
                          },
                          validator: (val) {
                            return validInput(val, 2, 30, "يكون اسم الوجبة");
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fastfood),
                            labelText: "اكتب هنا اسم الوجبة",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        TextFormField(
                          onSaved: (val) {
                            itemnameen = val;
                          },
                          validator: (val) {
                            return validInput(val, 2, 30, "يكون اسم الوجبة");
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fastfood),
                            labelText: "اكتب هنا اسم الوجبة باللغة الانكليزية",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        TextFormField(
                          onSaved: (val) {
                            itemprice = val;
                          },
                          validator: (val) {
                            return validInput(
                                val, 0, 6, "يكون السعر", "number");
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.attach_money),
                            labelText: "اكتب هنا السعر  ",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        TextFormField(
                          onSaved: (val) {
                            itemdesc = val;
                          },
                          validator: (val) {
                            return validInput(val, 2, 100, "يكون وصف الوجبة");
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fastfood),
                            labelText: "اكتب هنا وصف الوجبة",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        DropdownSearch(
                          items: _datadropdown,
                          label: "اختر هنا اسم القسم",
                          onChanged: (val) {
                            _catname = val;
                          },
                          selectedItem: "اسم القسم",
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: RaisedButton(
                    child: Text(" اضف الصورة",
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                    color: Colors.red,
                    onPressed: showbottommenu,
                  ),
                ),
                Container(
                    width: 200,
                    height: 200,
                    child: file == null
                        ? Center(child: Text(" لم يتم اختيار صورة "))
                        : Image.file(file)),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: RaisedButton(
                    child: Text("اضافة وجبة",
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                    color: Colors.red,
                    onPressed: addItem,
                  ),
                )
              ],
            )));
  }

  showbottommenu() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            height: 200,
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
                    _choosecamera();
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  title: Text("Take Photo", style: TextStyle(fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    _choosegallery();
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
