import 'dart:math' as math;

import 'package:data_table_try/data/invoices.dart';
import 'package:data_table_try/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../../data/enums.dart';
import '../../../util/local_storage.dart';
import '../family_details_mv.dart';

class Invoices extends StatelessWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyDetailsMV>(
      builder: (context, data, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.invoices.length,
                itemBuilder: (context, index) {
                  Invoice invoice = data.invoices[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onLongPress: (data.invoices[index].description ==
                                  'null' ||
                              data.invoices[index].description == null)
                          ? null
                          : () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: Responsive.heightOfScreen(
                                        context: context, height: .4),
                                    color: Colors.grey.shade200,
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            data.invoices[index].description!,
                                            softWrap: true,
                                            textDirection: TextDirection.rtl,
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                      minLeadingWidth: 20,
                      style: ListTileStyle.drawer,
                      splashColor: Colors.blue,
                      tileColor: Colors.grey.shade200,
                      subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: (data.invoices[index].description == 'null' ||
                                  data.invoices[index].description == null)
                              ? const SizedBox()
                              : Text(
                                  '${invoice.description}',
                                  textDirection: TextDirection.rtl,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      leading: Container(
                        width: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0)),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.users![index],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          Text(
                              '${intl.DateFormat.Hms().format(invoice.dateTime!)}  ${intl.DateFormat.yMd().format(invoice.dateTime!)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${invoice.amount} الف د.ع',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 20),
                          ),
                          if (Prefs().userRole == UserRole.superAdmin)
                            IconButton(
                                onPressed: () {
                                  data.invoiceAmount = (invoice.amount! > 200 ||
                                          invoice.amount! < 5)
                                      ? 5
                                      : invoice.amount!.toDouble();
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          Consumer<FamilyDetailsMV>(
                                            builder: (context, data2, child) =>
                                                AlertDialog(
                                              scrollable: false,
                                              title: const Text(
                                                'تعديل الفاتورة',
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(fontSize: 30),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'الغاء',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .lightBlueAccent),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      data2.editInvoice(
                                                          context,
                                                          data2.invoices[index]
                                                              .id!),
                                                  child: const Text('تأكيد',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .lightBlueAccent)),
                                                ),
                                              ],
                                              content: SizedBox(
                                                width: Responsive.widthOfScreen(
                                                    context: context,
                                                    width: .7),
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Text.rich(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            TextSpan(children: [
                                                              const TextSpan(
                                                                  text:
                                                                      'اسم العائلة : '),
                                                              TextSpan(
                                                                  text: data2
                                                                      .family
                                                                      ?.providerName)
                                                            ]),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Text(
                                                              'رقم الهاتف : ${data2.family?.providerPhone}'),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Text(
                                                            ' المبلغ المدفوع : ${data2.invoiceAmount.round()} الف دينار عراقي',
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Text('5'),
                                                            Expanded(
                                                              child: Slider(
                                                                value: data2
                                                                    .invoiceAmount,
                                                                max: 200,
                                                                min: 5,
                                                                divisions: 39,
                                                                label: data2
                                                                    .invoiceAmount
                                                                    .round()
                                                                    .toString(),
                                                                onChanged: (double
                                                                        value) =>
                                                                    data2.changeSliderValue(
                                                                        value),
                                                              ),
                                                            ),
                                                            const Text('200')
                                                          ],
                                                        ),
                                                        const Text(
                                                            ' : ملاحظات'),
                                                        TextFormField(
                                                          initialValue: invoice
                                                              .description,
                                                          maxLength: 1000,
                                                          maxLines: 5,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          onChanged: (description) =>
                                                              data2.invoiceDescription =
                                                                  description,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              6),
                                                                  border:
                                                                      OutlineInputBorder()),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ));
                                },
                                icon: const Icon(
                                    Icons.mode_edit_outline_outlined))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
