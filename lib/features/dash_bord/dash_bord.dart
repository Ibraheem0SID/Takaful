import 'package:data_table_try/features/dash_bord/widgets/customCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/enums.dart';
import '../../util/local_storage.dart';
import '../new_family/add_family.dart';
import 'cities/cities.dart';
import 'dash_bord_mv.dart';
import 'widgets/deleted_families_button.dart';
import 'widgets/home_chart.dart';
import 'widgets/invoice_button.dart';

class DashBord extends StatefulWidget {
  const DashBord({Key? key}) : super(key: key);

  @override
  State<DashBord> createState() => _DashBordState();
}

class _DashBordState extends State<DashBord> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DashBordMV>(context, listen: false).fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Consumer<DashBordMV>(
          builder: (context, data, child) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: RefreshIndicator(
              onRefresh: () => data.refresh(),
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CustomCard(
                              text: 'مجموع العوائل المتعففة :',
                              value: data.activeFamiliesCount.toString()),
                          const SizedBox(
                            width: 20,
                          ),
                          CustomCard(
                              text: 'المبلغ المدفوع هذا الشهر :',
                              value: '${data.totalMoneySpent} د.ع '),
                        ],
                      ),
                    ),
                    if (Prefs().userRole != UserRole.readOnly)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DeletedFamiliesButton(),
                            TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddFamily(),
                                    )),
                                child: const Text(
                                  'عائلة جديدة',
                                  style: TextStyle(fontSize: 20),
                                ))
                          ],
                        ),
                      ),
                    const HomePieChart(),
                    if (Prefs().userRole != UserRole.readOnly)
                      const InvoiceButton(),
                    if (Prefs().userRole != UserRole.readOnly)
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Cities(),
                              )),
                          child: const Text(
                            'قائمة المناطق',
                            style: TextStyle(fontSize: 20),
                          ))
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
