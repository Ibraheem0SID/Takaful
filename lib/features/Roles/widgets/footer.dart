import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../roles_MV.dart';

class PageFooter extends StatelessWidget {
  const PageFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RolesMV>(
      builder: (context, data, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${data.meta["from"]} - ${data.meta["to"]} of ${data.meta["total"]}'),
          IconButton(
            onPressed: data.previousPage(),
            icon: const Icon(Icons.navigate_before),
            disabledColor: Colors.grey,
          ),
          IconButton(
            onPressed: data.nextPage(),
            icon: const Icon(Icons.navigate_next),
            disabledColor: Colors.grey,
          ),
          (data.changeMade)
              ? const SizedBox(
                  width: 30,
                  child: LinearProgressIndicator(),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
