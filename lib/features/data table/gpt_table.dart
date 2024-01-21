import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gpt_tableMV.dart';
import 'widget/families_table.dart';
import 'widget/from_to.dart';
import 'widget/header.dart';
import 'widget/page_navigation_bar.dart';

class GptTable extends StatefulWidget {
  const GptTable({super.key});

  @override
  State<GptTable> createState() => _GptTableState();
}

class _GptTableState extends State<GptTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GptTableMV>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Consumer<GptTableMV>(
        builder: (context, data, child) => RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () => data.refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  ' العوائل المتعففة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Header(),
                  PageFromTo(),
                  FamiliesTable(),
                  PagesNavigationBar(),
                ],
              ),
            ]),
          ),
        ),
      ),
    ));
  }
}
