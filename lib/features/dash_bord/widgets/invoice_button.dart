import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dash_bord_mv.dart';
import 'invoice_dialog.dart';

class InvoiceButton extends StatelessWidget {
  const InvoiceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) => ChangeNotifierProvider.value(
            value: context.read<DashBordMV>(),
            child: const SingleChildScrollView(
              child: InvoiceDialog(),
            ),
          ),
        );
      },
      child: Text(
        'دفع مستحقات',
        style: TextStyle(fontSize: 20, color: Colors.teal.shade300),
      ),
    );
  }
}
