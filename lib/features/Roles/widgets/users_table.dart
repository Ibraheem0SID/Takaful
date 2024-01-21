import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../roles_MV.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<RolesMV>(
          builder: (context, data, child) => DataTable(
              dataRowColor: const MaterialStatePropertyAll(Colors.transparent),
              dataRowHeight: 70,
              headingRowHeight: 0,
              dividerThickness: 2,
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
              ],
              rows: data.rows),
        ),
      ),
    );
  }
}
