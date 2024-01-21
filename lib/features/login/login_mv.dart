import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';
import '../../util/api_helper.dart';
import '../../util/local_storage.dart';

class LoginMV extends ChangeNotifier {
  late String email;
  late String password;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String emailText = " اسم المستخدم ";
  String passwordText = " كلمة المرور ";
  String logInText = " تسجيل الدخول ";
  Text welcome = const Text("  مرحبا بك ",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
  Icon welcomeIcon = Icon(
    Icons.waving_hand,
    size: 40,
    color: Colors.yellow.shade600,
  );
  String userText = " إسم المستخدم ";

  final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9_\-=@,\.]+$");

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'يجب ادخال اسم المستخدم';
    } else if (!emailRegExp.hasMatch(value)) {
      return "تحتوي كلمة المرور على رموز غير مقبولة";
    }
    return null;
  }

  onSavedEmail(String? value) {
    email = value!;
  }

  String? passwordValidator(value) {
    if (value!.isEmpty) {
      return "يرجى إدخال كلمة المرور";
    } else if (value.length < 8) {
      return "كلمة المرور قصيرة";
    }
    return null;
  }

  onSavedPassword(value) {
    password = value!;
  }

  logIn(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var response = await ApiBase().post(
          url: 'auth/login',
          body: {'username': email, 'password': password},
          containHeaders: false);
      if (response != null) {
        if (response["message"] ==
            'These credentials do not match our records.') {
          Fluttertoast.showToast(
              msg: 'اسم المستخدم او كلمة المرور خاطئة',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red.shade300,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Prefs().setUserId(response["user_id"]);
          Prefs().setToken(response["token"]);
          var userInfo = await ApiBase().get(url: 'profile/details');
          Prefs().setUserRole(userInfo["data"]["role"]);
          print(Prefs().token);
          print(Prefs().userRole);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MyApp()));
        }
        // Do something with the user's input
      }
    }
  }
}
