import 'package:data_table_try/data/user.dart';
import 'package:data_table_try/features/login/log_in.dart';
import 'package:data_table_try/util/api_helper.dart';
import 'package:data_table_try/util/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'password form.dart';

class ProfileMV extends ChangeNotifier {
  User? user;
  final formKey = GlobalKey<FormState>();
  late TextEditingController pass;
  late TextEditingController confirmPass;
  late TextEditingController currentPassword;
  bool isLoading = false;
  bool wrongPassword = false;

  getUserInfo() async {
    isLoading = true;
    notifyListeners();
    var response = await ApiBase().get(url: 'profile/details');
    if (response != null) {
      user = User.fromJson(response["data"]);
      Prefs().setUserRole(user!.role!.number);
    }
    isLoading = false;
    notifyListeners();
  }

  passwordValidator(value) {
    if (value.isEmpty) {
      return "هذا الحقل مطلوب";
    } else if (value.length < 8) {
      return "كلمة المرور اطول من 8 رموز";
    } else {
      return null;
    }
  }

  confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return "هذا الحقل مطلوب";
    } else if (value.length < 8) {
      return "كلمة المرور اطول من 8 رموز";
    } else if (value != pass.text) {
      return "كلمة المرور غير متطابقة";
    } else {
      return null;
    }
  }

  showPasswordForm(BuildContext context) {
    currentPassword = TextEditingController();
    pass = TextEditingController();
    confirmPass = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ChangePasswordDialog();
        });
  }

  changePassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var response = await ApiBase().put(url: 'profile/update', body: {
        "name": user?.name,
        "username": user?.userName,
        "current_password": currentPassword.text,
        "password": pass.text,
        "password_confirmation": confirmPass.text,
      });
      if (response != null) {
        if (response["message"] == "The current password is not correct.") {
          Fluttertoast.showToast(
              msg: 'كلمة المرور التي ادخلتها خاطئة',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red.shade300,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          if (context.mounted) {
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: 'تم تغيير كلمة المرور بنجاح',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green.shade300,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }
    }
  }

  logout(BuildContext context) async {
    await ApiBase().post(url: 'auth/logout');
    Prefs().deleteLocalStorage();
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    }
  }

  disposeControllers() {
    pass.dispose();
    confirmPass.dispose();
    currentPassword.dispose();
  }
}
