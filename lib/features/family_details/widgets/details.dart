import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../family_details_mv.dart';

class Information extends StatelessWidget {
  const Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyDetailsMV>(
      builder: (context, data, child) => RefreshIndicator(
        onRefresh: () => data.getDetails(data.family!.id!),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.familyDetailsWidgets,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.label,
    required this.text,
  });
  final String? label;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$label',
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              (text == null || text == 'null') ? 'لا يوجد' : '$text',
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ));
  }
}
