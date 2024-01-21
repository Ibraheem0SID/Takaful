import 'dart:math';

import 'package:data_table_try/util/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/user.dart';

class RolesMV extends ChangeNotifier {
  List<User> users = [];
  List<DataRow> rows = [];
  late Map<String, dynamic> meta;
  late Map<String, dynamic> links;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController userName;
  late TextEditingController password;
  int userRoleValue = 3;

  bool changeMade = false;

  getUsersData() async {
    var response = await ApiBase().get(url: 'users');
    setData(response);
    notifyListeners();
  }

  setData(var response) {
    if (response != null) {
      List<dynamic> usersData = response["data"];
      users = usersData.map((e) => User.fromJson(e)).toList();
      rows = users.map((e) => getDataRow(e)).toList();
      meta = response["meta"];
      links = response["links"];
    }
  }

  dynamic nextPage() {
    return (links["next"] == null)
        ? null
        : () async {
            changeMade = true;
            notifyListeners();
            var response = await ApiBase()
                .get(fullUrl: links["next"], queryParameters: {"perPage": 5});
            setData(response);
            changeMade = false;
            notifyListeners();
          };
  }

  previousPage() {
    return (links["prev"] == null)
        ? null
        : () async {
            changeMade = true;
            notifyListeners();
            var response = await ApiBase().get(fullUrl: links["prev"]);
            setData(response);
            changeMade = false;
            notifyListeners();
          };
  }

  initializeControllers() {
    name = TextEditingController();
    userName = TextEditingController();
    password = TextEditingController();
    print('init');
    notifyListeners();
  }

  disposeControllers() {
    name.dispose();
    userName.dispose();
    password.dispose();
    print('desposed');
  }

  addNewMember(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var response = await ApiBase().post(url: 'users/', body: {
        "name": name.text,
        "username": userName.text,
        "password": password.text,
        "password_confirmation": password.text,
        "role": "$userRoleValue"
      });
      if (context.mounted && response != null) {
        if (response["message"] != 'The username has already been taken.') {
          Fluttertoast.showToast(
              msg: ' تم إضافة ${name.text} كعضو جديد ',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green.shade300,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
          userRoleValue = 3;
          getUsersData();
        } else {
          Fluttertoast.showToast(
              msg: 'اسم المستخدم موجود مسبقا',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red.shade300,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  passwordValidator(value) {
    if (value.isEmpty) {
      return "هذا الحقل مطلوب";
    } else if (value.length < 8) {
      return "يجب ان تكون كلمة المرور اطول من 8 رموز";
    } else {
      return null;
    }
  }

  nameValidator(value) {
    if (value.isEmpty) {
      return "هذا الحقل مطلوب";
    } else if (value.length < 2) {
      return "الاسم من حرفين على الأقل";
    } else {
      return null;
    }
  }

  userNameValidator(String? value) {
    final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9_\-=@,.]+$");
    if (value!.isEmpty) {
      return 'هذا الحقل مطلوب';
    } else if (!emailRegExp.hasMatch(value)) {
      return "يحتوي معرف العضو على رموز غير مقبولة";
    }
    return null;
  }

  setRoleValue(int value) {
    userRoleValue = value;
    notifyListeners();
  }

  DataRow getDataRow(User user, {BuildContext? context}) {
    final color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return DataRow(
      cells: [
        DataCell(
          CircleAvatar(
            backgroundColor: color,
            radius: 25,
          ),
        ),
        DataCell(
          Text(
            user.name!,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        (user.role!.number != 1)
            ? DataCell(
                DropdownButton(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  iconEnabledColor: Colors.lightBlueAccent,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  value: user.role!.number,
                  items: const [
                    DropdownMenuItem(
                      value: 3,
                      child: Text('ReadOnly'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('ReadWrite'),
                    ),
                  ],
                  onChanged: (value) {
                    editRole(user, value!);
                  },
                ),
              )
            : const DataCell(Text('SuperAdmin')),
        (user.role!.number != 1)
            ? DataCell(
                IconButton(
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    deleteUser(user.id!);
                  },
                ),
              )
            : const DataCell(SizedBox()),
      ],
    );
  }

  editRole(User user, int newRole) async {
    if (user.role?.number == newRole) return;
    changeMade = true;
    notifyListeners();
    var response = await ApiBase().patch(url: "users/${user.id}", body: {
      "role": "$newRole",
      "name": "${user.name}",
      "username": "${user.userName}"
    });
    if (response != null) {
      int index =
          users.indexWhere((element) => element.id == response["data"]["id"]);
      users[index] = User.fromJson(response["data"]);
      rows[index] = getDataRow(User.fromJson(response["data"]));
    }
    changeMade = false;
    notifyListeners();
  }

  deleteUser(int userId) async {
    changeMade = true;
    notifyListeners();
    await ApiBase().delete(url: "users/$userId");
    getUsersData();
    changeMade = false;
    notifyListeners();
  }
}
