import 'package:data_table_try/data/city.dart';
import 'package:data_table_try/data/enums.dart';
import 'package:data_table_try/data/family.dart';
import 'package:data_table_try/util/local_storage.dart';
import 'package:flutter/material.dart';

import '../../util/api_helper.dart';
import '../family_details/family_details.dart';
import 'custom_card.dart';

class GptTableMV extends ChangeNotifier {
  List<Map<String, dynamic>> dataTableData = [];
  Map<String, dynamic> meta = {};
  List<Family> families = [];
  int perPage = 10;
  List pages = [];
  bool ascending = true;
  int sortedColumnIndex = 14;
  String sortedColumnName = "id";
  String filteredColumn = "";
  int? filteredColumnValue;
  String? searchedValue = "";
  List<String> columnsName = [
    'نوع الدخل',
    'عدد الاسهم',
    'الايجار',
    'نوع السكن',
    'الدخل',
    'العنوان',
    'المنطقة',
    'نوع العائلة',
    'حالة العائلة',
    'الحالة الاجتماعية',
    'عدد القاصرين',
    'عدد الافراد',
    'الهاتف',
    'مسؤول العائلة',
    'رقم العائلة',
  ];
  List<City>? cities;

  fetchData({String? fullUrl}) async {
    var response = await ApiBase().get(
        url: "families",
        queryParameters: {
          (filteredColumn.isEmpty) ? null : "filters": {
            filteredColumn: filteredColumnValue
          },
          "sorting": {
            "col": sortedColumnName,
            "dir": ascending ? "asc" : "desc"
          },
          "perPage": perPage,
          "search": searchedValue
        },
        fullUrl: fullUrl);
    meta = response["meta"];
    pages = generatePages(meta["links"]);
    dataTableData = List<Map<String, dynamic>>.from(response["data"]);
    families = dataTableData.map((e) {
      print(e["id"]);
      return Family.fromJson(e);
    }).toList();
    notifyListeners();
  }

  refresh() async {
    sortedColumnName = "id";
    ascending = true;
    perPage = 10;
    searchedValue = "";
    filteredColumn = "";
    await fetchData();
  }

  changePerPage(int? value) {
    perPage = value!;
    fetchData();
  }

  search(value) {
    searchedValue = value;
    fetchData();
  }

  List generatePages(links) {
    final pages = [];
    final previousIndex =
        links.indexWhere((link) => link['label'] == '&laquo; Previous');
    final nextIndex =
        links.indexWhere((link) => link['label'] == 'Next &raquo;');
    links[previousIndex]["label"] = "السابق";
    links[nextIndex]["label"] = "التالي";
    if (previousIndex != -1 && nextIndex != -1) {
      pages.add(links[previousIndex]);

      for (var i = previousIndex + 1; i < nextIndex; i++) {
        pages.add(links[i]);
      }

      pages.add(links[nextIndex]);
    }

    return pages;
  }

  changePage(String? url) {
    fetchData(fullUrl: url);
  }

  getCities() async {
    var response =
        await ApiBase().get(url: "cities", queryParameters: {"perPage": 50});
    List data = response["data"];
    cities = data.map((e) => City.fromJson(e)).toList();
    notifyListeners();
  }

  List<DataColumn> getTableColumns() {
    List columnsToSort = [1, 2, 4, 10, 11, 13, 14];
    List columnsToFilter = [0, 3, 7, 8, 9];
    String? indexToString(int index) {
      switch (index) {
        case 0:
          return "income_type";
        case 1:
          return "shares_count";
        case 2:
          return "rent_cost";
        case 3:
          return "housing_type";
        case 4:
          return "income";
        case 7:
          return "type";
        case 8:
          return "status";
        case 9:
          return "provider_social_status";
        case 10:
          return "youngers_count";
        case 11:
          return "members_count";
        case 13:
          return "provider_name";
        case 14:
          return "id";
      }
      return null;
    }

    indexToEnum(int index) {
      switch (index) {
        case 0:
          return IncomeType.values.map((e) => {e.value: e.number}).toList();
        case 3:
          return HousingType.values.map((e) => {e.value: e.number}).toList();
        case 7:
          return FamilyType.values.map((e) => {e.value: e.number}).toList();
        case 8:
          return FamilyStatus.values.map((e) => {e.value: e.number}).toList();
        case 9:
          return ProviderSS.values.map((e) => {e.value: e.number}).toList();
      }
    }

    return dataTableData.isNotEmpty
        ? columnsName
            .map((e) => DataColumn(
                numeric: true,
                label: Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (columnsToFilter.contains(columnsName.indexOf(e)))
                          ? SizedBox(
                              width: 50,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  elevation: 10,
                                  itemHeight: 50,
                                  isExpanded: true,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  items: indexToEnum(columnsName.indexOf(e))
                                      ?.map((element) {
                                    return DropdownMenuItem(
                                      enabled: (element.values.first == null)
                                          ? false
                                          : true,
                                      value: element.values.first,
                                      child: (element.values.first == null)
                                          ? SizedBox()
                                          : Text(
                                              element.keys.first,
                                            ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    filteredColumnValue = value;
                                    filteredColumn =
                                        indexToString(columnsName.indexOf(e))!;
                                    fetchData();
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(),
                      if (e == 'المنطقة')
                        if (cities != null)
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              onChanged: (value) {
                                filteredColumnValue = value;
                                filteredColumn = 'city_id';
                                fetchData();
                              },
                              onTap: () {
                                getCities();
                              },
                              items: cities
                                  ?.map((city) => DropdownMenuItem(
                                        value: city.id,
                                        child: Text('${city.name}'),
                                      ))
                                  .toList(),
                            ),
                          )
                        else
                          IconButton(
                              onPressed: () => getCities(),
                              icon: Icon(Icons.refresh_outlined)),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        e,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                onSort: (columnsToSort.contains(columnsName.indexOf(e)))
                    ? (columnIndex, asc) {
                        ascending = !ascending;
                        sortedColumnIndex = columnIndex;
                        sortedColumnName =
                            indexToString(columnsName.indexOf(e))!;
                        fetchData();
                      }
                    : null))
            .toList()
        : [];
  }

  List<DataRow> getDataRows(BuildContext context) {
    List<Color> incomeTypeColors(IncomeType incomeType) {
      //the first index is for the card, the other one is for the text inside.
      switch (incomeType) {
        case IncomeType.aid:
          return const [Color(0xffeff3ff), Color(0xff2a63b1)];
        case IncomeType.martyrs:
          return const [Color(0xffe7f7ef), Color(0xff57a87a)];
        case IncomeType.retired:
          return const [Color(0xfff9eeff), Color(0xffb576e8)];
        case IncomeType.others:
          return const [Color(0xffeef5e5), Color(0xffa6a9b0)];
        case IncomeType.none:
          return const [Color(0xffeef5e5), Color(0xffa6a9b0)];
      }
    }

    List<Color> housingTypeColors(HousingType housingType) {
      // index 0 is for the card, 1 for the text inside.
      switch (housingType) {
        case HousingType.ownership:
          return const [Color(0xffeef5e5), Color(0xffa6a9b0)];
        case HousingType.rent:
          return const [Color(0xffeef5e5), Color(0xffa6a9b0)];
        case HousingType.illegal:
          return const [Color(0xfff9eeff), Color(0xffb576e8)];
        case HousingType.others:
          return const [Color(0xffe7f7ef), Color(0xff57a87a)];
        case HousingType.none:
          return const [Color(0xffeff3ff), Color(0xff2a63b1)];
      }
    }

    List<Color> familyTypeColors(FamilyType familyType) {
      // index 0 is for the card, 1 for the text inside.
      switch (familyType) {
        case FamilyType.chase:
          return const [Color(0xffF9EBE0), Color(0xff4E342E)];
        case FamilyType.missing:
          return const [Color(0xffE1F5FE), Color(0xff0277BD)];
        case FamilyType.noProvider:
          return const [Color(0xffFFF3E0), Color(0xffE64A19)];
        case FamilyType.orphans:
          return const [Color(0xffF3E5F5), Color(0xff6A1B9A)];
        case FamilyType.specialNeeds:
          return const [Color(0xffE8F5E9), Color(0xff1B5E20)];
        case FamilyType.others:
          return const [Color(0xffFBE9E7), Color(0xffBF360C)];
        case FamilyType.none:
          return const [Color(0xffE0F7FA), Color(0xff00838F)];
      }
    }

    List<Color> familyStatusColors(FamilyStatus familyStatus) {
      // index 0 is for the card, 1 for the text inside.
      switch (familyStatus) {
        case FamilyStatus.veryWeak:
          return const [Color(0xffFFF8E1), Color(0xffFF8F00)];
        case FamilyStatus.weak:
          return const [Color(0xffFCE4EC), Color(0xffC2185B)];
        case FamilyStatus.average:
          return const [Color(0xffE3F2FD), Color(0xff1565C0)];
        case FamilyStatus.none:
          return const [Color(0xffF1F8E9), Color(0xff827717)];
      }
    }

    List<Color> providerSSColors(ProviderSS providerSS) {
      // index 0 is for the card, 1 for the text inside.
      switch (providerSS) {
        case ProviderSS.divorced:
          return const [Color(0xffFFEBEE), Color(0xffD50000)];
        case ProviderSS.hanging:
          return const [Color(0xffF0F4C3), Color(0xff827717)];
        case ProviderSS.married:
          return const [Color(0xffB3E5FC), Color(0xff01579B)];
        case ProviderSS.missing:
          return const [Color(0xffFFCCBC), Color(0xffBF360C)];
        case ProviderSS.specialNeeds:
          return const [Color(0xffDCEDC8), Color(0xff33691E)];
        case ProviderSS.widow:
          return const [Color(0xffFCE4EC), Color(0xff880E4F)];
        case ProviderSS.none:
          return const [Color(0xffFFD180), Color(0xffFF6F00)];
      }
    }

    return families
        .map((family) => DataRow(
              color: MaterialStatePropertyAll((families.indexOf(family).isOdd)
                  ? Colors.grey.shade300
                  : Colors.transparent),
              onSelectChanged: (Prefs().userRole == UserRole.readOnly)
                  ? null
                  : (bool? selected) {
                      if (selected != null && selected) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FamilyDetails(id: family.id!),
                            ));
                      }
                    },
              cells: [
                DataCell(InfoCard(
                    textValue: family.incomeType!.value,
                    colors: incomeTypeColors(family.incomeType!))),
                DataCell(CustomText(
                  value: family.sharesCount,
                )),
                DataCell(CustomText(
                  value: family.rentCost,
                )),
                DataCell(InfoCard(
                    textValue: family.housingType!.value,
                    colors: housingTypeColors(family.housingType!))),
                DataCell(CustomText(
                  value: family.income,
                )),
                DataCell(Center(
                    child: Text((family.address == null)
                        ? 'لا يوجد'
                        : family.address.toString()))),
                DataCell(CustomText(
                  value: family.cityID,
                )),
                DataCell(InfoCard(
                    textValue: family.type!.value,
                    colors: familyTypeColors(family.type!))),
                DataCell(InfoCard(
                    textValue: family.status!.value,
                    colors: familyStatusColors(family.status!))),
                DataCell(InfoCard(
                    textValue: family.providerSS!.value,
                    colors: providerSSColors(family.providerSS!))),
                DataCell(CustomText(
                  value: family.youngersCount,
                )),
                DataCell(CustomText(
                  value: family.membersCount,
                )),
                DataCell(Center(child: Text(family.providerPhone.toString()))),
                DataCell(Text(
                  family.providerName.toString(),
                  textDirection: TextDirection.rtl,
                )),
                DataCell(Center(
                  child: Text(
                    family.id.toString(),
                  ),
                )),
              ],
            ))
        .toList();
  }
}

class CustomText extends StatelessWidget {
  const CustomText({Key? key, required this.value}) : super(key: key);

  final int? value;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text((value == null) ? 'لا يوجد' : value.toString()));
  }
}
