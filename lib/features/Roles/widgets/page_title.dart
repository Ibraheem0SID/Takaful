import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          'الاعضاء',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
