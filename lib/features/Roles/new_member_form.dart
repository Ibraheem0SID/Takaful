import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'roles_MV.dart';

class AddNewMemberForm extends StatefulWidget {
  const AddNewMemberForm({super.key});

  @override
  State<AddNewMemberForm> createState() => _AddNewMemberFormState();
}

class _AddNewMemberFormState extends State<AddNewMemberForm> {
  @override
  void deactivate() {
    Provider.of<RolesMV>(context, listen: false).disposeControllers();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Consumer<RolesMV>(
          builder: (context, data, child) => AlertDialog(
            title: const Text(
              ' عضو جديد',
              textDirection: TextDirection.rtl,
            ),
            content: Form(
              key: data.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    label: 'إسم العضو',
                    controller: data.name,
                    validator: (value) => data.nameValidator(value),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        label: 'معرف العضو',
                        controller: data.userName,
                        validator: (value) => data.userNameValidator(value),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: const Text(
                                'الصلاحية',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            DropdownButton(
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              iconEnabledColor: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(12),
                              value: data.userRoleValue,
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
                              onChanged: (value) => data.setRoleValue(value!),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  CustomTextField(
                    label: 'كلمة المرور',
                    validator: (value) => data.passwordValidator(value),
                    controller: data.password,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'الغاء',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ),
              TextButton(
                onPressed: () => data.addNewMember(context),
                child: const Text('اضافة',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.label, this.controller, this.validator});
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
            label: Text(
              label,
            ),
            border: const OutlineInputBorder(),
            errorMaxLines: 3),
        controller: controller,
        validator: validator,
      ),
    );
  }
}
