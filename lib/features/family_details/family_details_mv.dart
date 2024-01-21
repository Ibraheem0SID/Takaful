import 'dart:convert';

import 'package:data_table_try/data/invoices.dart';
import 'package:data_table_try/features/family_details/widgets/details.dart';
import 'package:data_table_try/util/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/family.dart';

class FamilyDetailsMV extends ChangeNotifier {
  int pageIndex = 0;
  Family? family;
  String city = 'لا يوجد';
  List<Widget> familyDetailsWidgets = [];
  List<Invoice> invoices = [];
  Map<String, dynamic> links = {};
  List? users;
  double invoiceAmount = 5;
  String? invoiceDescription;

  changePage(int index) {
    pageIndex = index;
    notifyListeners();
  }

  deleteFamily(BuildContext context) async {
    await ApiBase().delete(url: "families/${family?.id}");
    if (context.mounted) Navigator.pop(context);
  }

  getDetails(int id) async {
    family = null;
    familyDetailsWidgets = [];
    var response = await ApiBase().get(url: "families/$id");
    family = Family.fromJson(response["data"]);
    await getCityName();
    family?.details().forEach((key, value) {
      familyDetailsWidgets.add(CustomText(
          label: key,
          text: (key == 'المدينة')
              ? city
              : (key == 'الايجار' || key == 'الراتب')
                  ? (value != null && value != 'null')
                      ? '$value د.ع '
                      : 'لا يوجد'
                  : value.toString()));
    });

    notifyListeners();
  }

  getInvoices(int id) async {
    invoices = [];
    notifyListeners();
    var response = await ApiBase().get(url: "families/$id/invoices");
    if (response != null) {
      List<dynamic> data = response["data"];
      invoices =
          data.map((jsonInvoice) => Invoice.fromJson(jsonInvoice)).toList();
      links = response["links"];

      users = data.map((jsonInvoice) {
        if (jsonInvoice["user"] != null) {
          return jsonInvoice["user"]["name"];
        } else {
          return 'لا احد';
        }
      }).toList();

      notifyListeners();
    }
  }

  editInvoice(BuildContext context, int id) async {
    var response = await ApiBase().patch(
        url: "invoices/$id",
        body: jsonEncode({
          "family_id": family?.id,
          "amount": invoiceAmount.toInt(),
          "description": invoiceDescription
        }),
        contentType: true);
    if (context.mounted && response != null) {
      Fluttertoast.showToast(
          msg:
              ' تم اجراء التعديل\n ${invoiceAmount.round()}الف للعائلة رقم  ${family?.id}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pop();
      invoiceDescription = null;
      getInvoices(family!.id!);
    }
  }

  changeSliderValue(double value) {
    invoiceAmount = value;
    notifyListeners();
  }

  nextPage() {
    return (links["next"] == null)
        ? null
        : () async {
            var response = await ApiBase().get(fullUrl: links["next"]);
            List<dynamic> data = response["data"];
            invoices = data
                .map((jsonInvoice) => Invoice.fromJson(jsonInvoice))
                .toList();
            links = response["links"];
            notifyListeners();
          };
  }

  previousPage() {
    return (links["prev"] == null)
        ? null
        : () async {
            var response = await ApiBase().get(fullUrl: links["prev"]);
            List<dynamic> data = response["data"];
            invoices = data
                .map((jsonInvoice) => Invoice.fromJson(jsonInvoice))
                .toList();
            links = response["links"];
            notifyListeners();
          };
  }

  getCityName() async {
    if (family?.cityID != null) {
      var response = await ApiBase().get(url: "cities/${family?.cityID}");
      if (response != null) {
        city = response["data"]['name'];
      }
    } else {
      city = 'لا يوجد';
    }
    notifyListeners();
  }
}
