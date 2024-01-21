import 'package:data_table_try/util/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/city.dart';

class CitiesMV extends ChangeNotifier {
  List<City> cities = [];
  bool loading = false;
  String? nextLink;
  late TextEditingController newCityController;

  fetchData() async {
    var response = await ApiBase().get(url: "cities");
    if (response != null) {
      List<Map<String, dynamic>> citiesData =
          List<Map<String, dynamic>>.from(response["data"]);
      cities = citiesData.map((e) => City.fromJson(e)).toList();
      nextLink = response["links"]["next"];
      notifyListeners();
    }
  }

  initializeControllers() {
    newCityController = TextEditingController();
    notifyListeners();
  }

  disposeControllers() {
    newCityController.dispose();
  }

  loadMore() async {
    if (nextLink != null) {
      loading = true;
      notifyListeners();
      var response = await ApiBase().get(fullUrl: nextLink);
      List<Map<String, dynamic>> citiesData =
          List<Map<String, dynamic>>.from(response["data"]);
      List<City> newCities = citiesData.map((e) => City.fromJson(e)).toList();
      cities.addAll(newCities);
      nextLink = response["links"]["next"];
      loading = false;
      notifyListeners();
    }
  }

  addNewCity() async {
    if (newCityController.text != '') {
      final City newCity = City(name: newCityController.text);
      var response =
          await ApiBase().post(url: "cities", body: newCity.toJson());
      if (response != null) {
        cities.add(City.fromJson(response["data"]));
        newCityController.clear();
        Fluttertoast.showToast(
            msg: 'تم اضافة المنطقة',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
        notifyListeners();
      } else {
        Fluttertoast.showToast(
            msg: 'حصل خطأ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  deleteCity(City city) async {
    var response = await ApiBase().delete(url: "cities/${city.id}");
    fetchData();
  }
}
