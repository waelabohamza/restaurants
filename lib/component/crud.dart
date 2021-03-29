import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';

String basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'TalabGoUser@58421710942258459:TalabGoPassword@58421710942258459'));
Map<String, String> myheaders = {
  // 'content-type': 'application/json',
  // 'accept': 'application/json',
  'authorization': basicAuth
};

class Crud {
  // var server = "10.0.2.2:8080/food";
  // var server = "http://192.168.1.2:8080/food";
  // var server = "almotorkw.com/talabgo/food" ;
  var server = "https://talabgo.com/food";

  Future readData(String url) async {
    if (url == "categories") {
      url = "$server/categories/categories.php";
    } else if (url == "items") {
      url = "$server/items/items.php";
    }
    if (url == "catsres") {
      url = "$server/catsres/catsres.php";
    }
    try {
      var response = await http.get(Uri.parse(url), headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("File Not Found ");
      }
    } catch (e) {
      print("caught error");
      print(e);
    }
  }

  Future readDataWhere(String url, String value) async {
    var data;
    if (url == "items") {
      url = "$server/items/items.php";
      data = {"resid": value};
    }
    if (url == "restaurant") {
      url = "$server/restaurants/restaurants.php";
      data = {"resid": value};
    }
    if (url == "countallres") {
      url = "$server/countallres.php";
      data = {'resid': value};
    }
    if (url == "ordersdetails") {
      url = "$server/delivery/orders_delivery_details.php";
      data = {"ordersid": value};
    }
    if (url == "delivery") {
      url = "$server/restaurants/delivery.php";
      data = {"deliveryres": value};
    }
    if (url == "messages") {
      url = "$server/message/messageres.php";
      data = {"resid": value};
    }
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      print(response.body);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("File Not Found ");
      }
    } catch (e) {
      print("caught error");
      print(e);
    }
  }

  Future writeData(String type, Map data) async {
    String url;

    if (type == "deleteitems") {
      url = "$server/items/deleteitems.php";
    }
    if (type == "login") {
      url = "$server/auth/res_login.php";
    }
    if (type == "signup") {
      url = "$server/auth/res_signup.php";
    }
    if (type == "savelocation") {
      url = "$server/auth/res_signup_two.php";
    }
    if (type == "signupthree") {
      url = "$server/auth/res_signup_three.php";
    }
    if (type == "settingsrestauratnt") {
      url = "$server/settings/settingsrestaurant.php";
    }
    if (type == "approveorders") {
      url = "$server/orders/orders_restaurants_approve.php";
    }
    if (type == "deleteusers") {
      url = "$server/users/deleteusers.php";
    }
    if (type == "orders") {
      url = "$server/orders/ordersrestaurants.php";
    }
    if (type == "doneprepare") {
      url = "$server/orders/doneprepare.php";
    }
    if (type == "doneorders") {
      url = "$server/orders/doneorders.php";
    }
    if (type == "report") {
      url = "$server/report/report.php";
    }
    if (type == "totalorders") {
      url = "$server/report/totalorders.php";
    }
    if (type == "denyorders") {
      url = "$server/orders/denyorders.php";
    }
    if (type == "bill") {
      url = "$server/money/billres.php";
    }
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("File Not Found ");
      }
    } catch (e) {
      print("caught error");
      print(e);
    }
  }

  addDeliveryWays(var data) async {
    var url = "$server/auth/res_signup_four.php";
    var response = await http.post(Uri.parse(url),
        body: json.encode(data), headers: myheaders);
    if (response.statusCode == 200) {
      print(response.body);
      var responsebody = jsonDecode(response.body);
      return responsebody;
    } else {
      print("page Not found");
    }
  }

  Future addItems(
      itemname, itemnameen, itemprice, catname, resid , itemdesc, File imagefile) async {
    var stream = new http.ByteStream(imagefile.openRead());
    stream.cast();
    var length = await imagefile.length();

    var uri = Uri.parse("$server/items/additems.php");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(imagefile.path));
    request.fields["item_name"] = itemname;
    request.fields["item_name_en"] = itemnameen;
    request.fields["item_price"] = itemprice;
    request.fields["cat_name"] = catname;
    request.fields["itemres"] = resid;
    request.fields["itemdesc"] = itemdesc;
    request.files.add(multipartFile);
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print(jsonDecode(response.body));
    }
  }

  Future editItems(
      itemid, itemname, itemnameen, itemprice, catname, bool issfile,
      [File imagefile]) async {
    var uri = Uri.parse("$server/items/edititems.php");

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    if (issfile == true) {
      var stream = new http.ByteStream(imagefile.openRead());
      stream.cast();
      var length = await imagefile.length();
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(imagefile.path));
      request.files.add(multipartFile);
    }

    request.fields["itemid"] = itemid;
    request.fields["item_name"] = itemname;
    request.fields["item_name_en"] = itemnameen;
    request.fields["item_price"] = itemprice;
    request.fields["cat_name"] = catname;

    var myrequest = await request.send();

    var response = await http.Response.fromStream(myrequest);

    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print(jsonDecode(response.body));
    }
  }

  Future signUpRestarants(String name, String password, String email,
      String phone, File imagelogo, File imagelisence) async {
    var stream = new http.ByteStream(imagelogo.openRead());
    stream.cast();
    var streamtwo = new http.ByteStream(imagelisence.openRead());
    stream.cast();
    var length = await imagelogo.length();
    var lengthtwo = await imagelisence.length();
    var uri = Uri.parse("$server/auth/res_signup.php");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(imagelogo.path));
    var multipartFileTwo = new http.MultipartFile(
        "filetwo", streamtwo, lengthtwo,
        filename: basename(imagelisence.path));
    // add Data to request
    request.fields["res_name"] = name;
    request.fields["res_password"] = password;
    request.fields["res_email"] = email;
    request.fields["res_phone"] = phone;

    // add Data to request
    request.files.add(multipartFile);
    request.files.add(multipartFileTwo);
    // Send Request
    var myrequest = await request.send();
    // For get Response Body
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      return jsonDecode(response.body);
    }
  }

  Future addUsers(
      email, password, username, phone, deliveryres, File imagefile) async {
    var stream = new http.ByteStream(imagefile.openRead());
    stream.cast();
    var length = await imagefile.length();
    var uri = Uri.parse("$server/delivery/adddelivery.php");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);

    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(imagefile.path));
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["username"] = username;
    request.fields["phone"] = phone;
    request.fields['role'] = "3";
    request.fields['deliveryres'] = deliveryres;

    request.files.add(multipartFile);
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }
}
