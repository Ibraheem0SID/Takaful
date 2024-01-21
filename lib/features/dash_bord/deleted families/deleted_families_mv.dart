import 'package:data_table_try/util/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:data_table_try/data/family.dart';

class DeletedFamiliesMV extends ChangeNotifier {
  List<Family> deletedFamilies = [];
  bool loading = false;
  String? nextLink;

  fetchData({int perPage = 15}) async {
    var response = await ApiBase().get(url: "families/trash", queryParameters: {
      "select": "id,provider_name,provider_phone,notes",
      "perPage": perPage
    });
    List<Map<String, dynamic>> familiesData =
        List<Map<String, dynamic>>.from(response["data"]);
    deletedFamilies = familiesData.map((e) => Family.fromJson(e)).toList();
    nextLink = response["links"]["next"];
    notifyListeners();
  }

  restoreFamily(int familyId) async {
    await ApiBase().post(url: "families/restore/$familyId");
    fetchData(perPage: deletedFamilies.length);
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
      deletedFamilies.addAll(newFamilies);
      nextLink = response["links"]["next"];
      loading = false;
      notifyListeners();
    }
  }
}
