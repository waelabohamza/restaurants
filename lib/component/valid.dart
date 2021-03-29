Pattern pattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
String pattern_number = r'(^(?:[+0]9)?[0-9])';
RegExp regExp = new RegExp(pattern_number);
validInput(String val, int min, int max,  String textvalid , [type]) {
  if (type == "email") {
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val)) {
      return " عنوان البريد غير صحيح يجب ان يكون على سبيل المثال مثل (example@gmail.com)";
    }
  }
  if (type == "number") {
    if (!regExp.hasMatch(val)) {
      return 'الرجاء ادخال ارقام فقط';
      }
  }

  if (val.trim().isEmpty) {
    return "لا يمكن ان $textvalid فارغ";
  }
  if (val.trim().length < min) {
    return " لا يمكن ان $textvalid اصفر من $min ";
  }
  if (val.trim().length > max) {
    return " لا يمكن ان $textvalid اكبر من $max ";

  }
}
