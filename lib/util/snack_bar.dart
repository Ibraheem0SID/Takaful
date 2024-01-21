import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
        content: Container(
      padding: EdgeInsets.all(16),
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: const [
          Text('حصل خطأ ما'),
          Text('هنا يعرض الخطأ'),
        ],
      ),
    ));
  }
}
