import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gpt_tableMV.dart';

class PageFromTo extends StatelessWidget {
  const PageFromTo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GptTableMV>(
      builder: (context, data, child) => data.dataTableData.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '${data.meta["from"]} - ${data.meta["to"]} of ${data.meta["total"]}'),
            )
          : const SizedBox(),
    );
  }
}
