import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'roles_MV.dart';
import 'widgets/footer.dart';
import 'widgets/new_member_button.dart';
import 'widgets/page_title.dart';
import 'widgets/users_table.dart';

class Roles extends StatefulWidget {
  const Roles({Key? key}) : super(key: key);

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RolesMV>(context, listen: false).getUsersData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RolesMV>(
          builder: (context, data, child) => RefreshIndicator(
            onRefresh: () => data.getUsersData(),
            child: Center(
              child: SingleChildScrollView(
                child: (data.rows.isEmpty)
                    ? CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          PageTitle(),
                          NewMemberButton(),
                          UsersTable(),
                          PageFooter(),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
