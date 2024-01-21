import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/responsive.dart';
import '../dash_bord_mv.dart';

class InvoiceDialog extends StatefulWidget {
  const InvoiceDialog({super.key});

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.maxScrollExtent == controller.offset) {
      Provider.of<DashBordMV>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBordMV>(
      builder: (context, data, child) => AlertDialog(
        scrollable: false,
        title: const Text(
          'دفع مستحقات',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          TextButton(
            onPressed: () {
              data.resetDialog();
              Navigator.pop(context);
            },
            child: const Text(
              'الغاء',
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              data.makeInvoice(context);
            },
            child: const Text('تأكيد',
                style: TextStyle(color: Colors.lightBlueAccent)),
          ),
        ],
        content: SizedBox(
          width: Responsive.widthOfScreen(context: context, width: .7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //show search field
              data.selectedFamily == null
                  ? TextFormField(
                      onChanged: (value) => data.search(value),
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                          hintText: "بحث",
                          hintStyle: TextStyle(
                            fontSize: 20,
                          ),
                          suffixIcon: Icon(Icons.search_sharp),
                          hintTextDirection: TextDirection.rtl,
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder()),
                    )
                  : const SizedBox(),
              //show search results
              data.filteredFamilies.isEmpty || data.selectedFamily != null
                  ? const SizedBox()
                  : Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            controller: controller,
                            shrinkWrap: true,
                            itemCount: data.filteredFamilies.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  data.filteredFamilies[index].providerName,
                                  textDirection: TextDirection.rtl,
                                ),
                                onTap: () => data
                                    .selectFamily(data.filteredFamilies[index]),
                                trailing: Text(
                                    data.filteredFamilies[index].id.toString()),
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    data.filteredFamilies[index].providerPhone
                                        .toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (data.loading)
                          const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator())
                      ],
                    ),
              //Display the form when user select a family
              data.selectedFamily == null
                  ? const SizedBox()
                  : SizedBox(
                      width: Responsive.widthOfScreen(
                        context: context,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () => data.goBack(),
                              icon: const Icon(Icons.arrow_back_ios_new)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text.rich(
                                    textDirection: TextDirection.rtl,
                                    TextSpan(children: [
                                      const TextSpan(text: 'اسم العائلة : '),
                                      TextSpan(
                                          text:
                                              data.selectedFamily?.providerName)
                                    ]),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                      'رقم الهاتف : ${data.selectedFamily?.providerPhone}'),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    ' المبلغ المدفوع : ${data.invoiceAmount.round()} الف دينار عراقي',
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text('5'),
                                    Expanded(
                                      child: Slider(
                                        value: data.invoiceAmount,
                                        max: 200,
                                        min: 5,
                                        divisions: 39,
                                        label: data.invoiceAmount
                                            .round()
                                            .toString(),
                                        onChanged: (double value) =>
                                            data.changeSliderValue(value),
                                      ),
                                    ),
                                    const Text('200')
                                  ],
                                ),
                                const Text(' : ملاحظات'),
                                TextField(
                                  maxLength: 1000,
                                  maxLines: 4,
                                  textDirection: TextDirection.rtl,
                                  onChanged: (description) =>
                                      data.invoiceDescription = description,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(6),
                                      border: OutlineInputBorder()),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
