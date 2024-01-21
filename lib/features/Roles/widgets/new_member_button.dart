import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../new_member_form.dart';
import '../roles_MV.dart';

class NewMemberButton extends StatelessWidget {
  const NewMemberButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Consumer<RolesMV>(
        builder: (context, data, child) => TextButton(
          onPressed: () {
            data.initializeControllers();
            showDialog(
                context: context,
                builder: (context) {
                  return const AddNewMemberForm();
                });
          },
          child: const Text(
            'عضو جديد',
          ),
        ),
      ),
    );
  }
}
