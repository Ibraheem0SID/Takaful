import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../new_family/add_family.dart';
import 'family_details_mv.dart';
import 'widgets/Invoices.dart';
import 'widgets/details.dart';

class FamilyDetails extends StatefulWidget {
  const FamilyDetails({super.key, required this.id});

  final int id;

  @override
  State<FamilyDetails> createState() => _FamilyDetailsState();
}

class _FamilyDetailsState extends State<FamilyDetails>
    with TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FamilyDetailsMV>(context, listen: false)
          .getDetails(widget.id);
      Provider.of<FamilyDetailsMV>(context, listen: false)
          .getInvoices(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FamilyDetailsMV>(
        builder: (context, data, child) => (data.family == null)
            ? const Center(child: CircularProgressIndicator())
            : DefaultTabController(
                length: 2,
                child: Scaffold(
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Card(
                          color: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddFamily(
                                                            family:
                                                                data.family),
                                                  ));
                                            },
                                            icon: const Icon(
                                                Icons.edit_outlined)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context1) =>
                                                    Consumer<FamilyDetailsMV>(
                                                  builder: (context1, value,
                                                          child) =>
                                                      AlertDialog(
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context1),
                                                        child: Text('الغاء'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          value.deleteFamily(
                                                              context);
                                                        },
                                                        child: Text('حذف'),
                                                      )
                                                    ],
                                                    content: const Text(
                                                      'حذف العائلة؟',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.delete_outlined)),
                                      ],
                                    ),
                                    Expanded(
                                      child: RichText(
                                        textDirection: TextDirection.rtl,
                                        text: TextSpan(
                                            text:
                                                '${data.family?.providerName}\n',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontFamily: 'tajwal',
                                                fontWeight: FontWeight.w500),
                                            children: [
                                              TextSpan(
                                                text:
                                                    data.family?.providerPhone,
                                              )
                                            ]),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                      minRadius: 25,
                                      maxRadius: 30,
                                      backgroundColor: Colors.deepPurple,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          data.family!.id.toString(),
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const TabBar(
                                  tabs: [
                                    Tab(
                                      icon: Icon(
                                        Icons.supervised_user_circle_outlined,
                                        size: 30,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    Tab(
                                      icon: Icon(
                                        Icons.payment_outlined,
                                        size: 30,
                                        color: Colors.deepPurple,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Information(),
                              Invoices(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
