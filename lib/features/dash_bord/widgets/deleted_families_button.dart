import 'package:flutter/material.dart';
import '../deleted families/deleted_families.dart';

class DeletedFamiliesButton extends StatelessWidget {
  const DeletedFamiliesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeletedFamilies(),
            )),
        child: const Text(
          'العوائل المحذوفة',
          style: TextStyle(fontSize: 20),
        ));
  }
}
