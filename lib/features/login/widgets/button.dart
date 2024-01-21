import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/responsive.dart';
import '../login_mv.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginMV>(
      builder: (context, data, child) => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        height: 50,
        width: Responsive.widthOfScreen(context: context),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextButton(
          child: const Text('تسجيل الدخول',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () => data.logIn(context),
        ),
      ),
    );
  }
}
