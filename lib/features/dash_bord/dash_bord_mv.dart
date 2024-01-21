import 'package:data_table_try/data/family.dart';
import 'package:data_table_try/data/invoices.dart';
import 'package:data_table_try/util/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashBordMV extends ChangeNotifier {
  int activeFamiliesCount = 0;
  int deletedFamiliesCount = 0;
  String totalMoneySpent = '0';
  int pendingFamilies = 0;
  List<Family> filteredFamilies = [];
  int touchedIndex = 1;
  Family? selectedFamily;
  String? nextLink;
  bool loading = false;
  double invoiceAmount = 5;
  String? invoiceDescription;

  fetchData() async {
    var response = await ApiBase().get(url: "home");
    activeFamiliesCount = response["activeFamiliesCount"];
    deletedFamiliesCount = response["deletedFamiliesCount"];
    pendingFamilies = response["pendingFamilies"];
    totalMoneySpent = (response["totalMoneySpent"] + '000').replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},');
    notifyListeners();
  }

  refresh() async {
    await fetchData();
  }

  search(String searchedValue) async {
    if (searchedValue.isEmpty) {
      filteredFamilies = [];
    } else {
      var response = await ApiBase().get(url: 'families', queryParameters: {
        "select": "id,provider_name,provider_phone,",
        "sorting": {"col": "provider_name", "dir": "asc"},
        "perPage": 10,
        "search": searchedValue
      });
      List<Map<String, dynamic>> familiesData =
          List<Map<String, dynamic>>.from(response["data"]);
      filteredFamilies = familiesData.map((e) => Family.fromJson(e)).toList();
      nextLink = response["links"]["next"];
    }
    notifyListeners();
  }

  loadMore() async {
    if (nextLink != null) {
      loading = true;
      notifyListeners();
      var response = await ApiBase().get(fullUrl: nextLink);
      List<Map<String, dynamic>> familiesData =
          List<Map<String, dynamic>>.from(response["data"]);
      List<Family> newFamilies =
          familiesData.map((e) => Family.fromJson(e)).toList();
      filteredFamilies.addAll(newFamilies);
      nextLink = response["links"]["next"];
      loading = false;
      notifyListeners();
    }
  }

  selectFamily(Family family) {
    selectedFamily = family;
    notifyListeners();
  }

  resetDialog() {
    selectedFamily = null;
    filteredFamilies = [];
  }

  makeInvoice(BuildContext context) async {
    Invoice invoice = Invoice(
        amount: invoiceAmount.toInt(),
        familyId: selectedFamily?.id,
        description: invoiceDescription);
    var response =
        await ApiBase().post(url: "invoices", body: invoice.toJson());

    if (context.mounted && response != null) {
      Fluttertoast.showToast(
          msg:
              ' تم دفع ${invoiceAmount.round()}الف للعائلة رقم  ${selectedFamily?.id}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pop();
      resetDialog();
      refresh();
    }
  }

  changeSliderValue(double value) {
    invoiceAmount = value;
    notifyListeners();
  }

  goBack() {
    selectedFamily = null;
    notifyListeners();
  }

  touchCallback(FlTouchEvent event, pieTouchResponse) {
    if (!event.isInterestedForInteractions ||
        pieTouchResponse == null ||
        pieTouchResponse.touchedSection == null) {
      touchedIndex = -1;
      return;
    }
    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
    notifyListeners();
  }

  List<PieChartSectionData> showingSections() {
    double pendingFamiliesPercentage =
        ((pendingFamilies / activeFamiliesCount) * 100);
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
      switch (i) {
        case 0:
          //pending families
          return PieChartSectionData(
            color: Colors.red.shade300,
            value: pendingFamilies.roundToDouble(),
            title:
                '$pendingFamilies\n${pendingFamiliesPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.teal.shade300,
            value: activeFamiliesCount - pendingFamilies.roundToDouble(),
            title:
                '${activeFamiliesCount - pendingFamilies}\n${(100 - pendingFamiliesPercentage).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        default:
          return PieChartSectionData();
      }
    });
  }
}
