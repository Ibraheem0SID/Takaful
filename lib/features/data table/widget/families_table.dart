import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gpt_tableMV.dart';

class FamiliesTable extends StatelessWidget {
  const FamiliesTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GptTableMV>(
      builder: (context, data, child) => data.dataTableData.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'لا يوجد بيانات',
                style: TextStyle(fontSize: 30),
              ),
            ))
          : SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.horizontal,
              child: Card(
                color: Colors.grey.shade200,
                child: DataTable(
                  showBottomBorder: true,
                  sortColumnIndex: data.sortedColumnIndex,
                  sortAscending: data.ascending,
                  showCheckboxColumn: false,
                  columns: data.getTableColumns(),
                  rows: data.getDataRows(context),
                ),
              ),
            ),
    );
  }
}
