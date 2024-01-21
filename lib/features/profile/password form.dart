import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_MV.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  @override
  void deactivate() {
    Provider.of<ProfileMV>(context, listen: false).disposeControllers();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileMV>(
      builder: (context, data, child) => AlertDialog(
        scrollable: true,
        title: const Text(
          'تغيير كلمة المرور',
          textDirection: TextDirection.rtl,
        ),
        content: Form(
          key: data.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PasswordTextField(
                label: 'كلمة المرور الحالية',
                validator: (value) => data.passwordValidator(value),
                controller: data.currentPassword,
              ),
              PasswordTextField(
                label: 'كلمة المرور الجديدة',
                controller: data.pass,
                validator: (value) => data.passwordValidator(value),
              ),
              PasswordTextField(
                label: 'تأكيد كلمة المرور',
                controller: data.confirmPass,
                validator: (value) => data.confirmPasswordValidator(value),
              ),
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
            onPressed: () => data.changePassword(context),
            child: const Text('تأكيد',
                style: TextStyle(color: Colors.lightBlueAccent)),
          ),
        ],
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  PasswordTextField(
      {super.key, required this.label, this.controller, this.validator});
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          label: Center(
            child: Text(
              label,
            ),
          ),
          border: OutlineInputBorder(),
        ),
        controller: controller,
        validator: validator,
      ),
    );
  }
}
