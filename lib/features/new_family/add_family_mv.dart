import 'dart:convert';

import 'package:data_table_try/data/city.dart';
import 'package:data_table_try/data/family.dart';
import 'package:data_table_try/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/enums.dart';
import '../../util/api_helper.dart';

class AddFamilyMv extends ChangeNotifier {
  int currentStep = 0;
  bool isLoading = true;
  bool updating = false;
  int? updateId;
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> thirdFormKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  late TextEditingController _addressController;
  int? rentCost;
  int? cityId;
  HousingType housingType = HousingType.none;
  List<City> cities = [];

  int? membersCount;
  int? youngCount;
  int? _sharesCount;
  late TextEditingController _otherOrgs;
  late TextEditingController _notes;
  int? income;
  IncomeType incomeType = IncomeType.none;
  FamilyType familyType = FamilyType.none;
  FamilyStatus familyStatus = FamilyStatus.none;
  ProviderSS providerSS = ProviderSS.none;

  initializeControllers() {
    _notes = TextEditingController();
    _otherOrgs = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
    isLoading = false;
    notifyListeners();
  }

  setFamilyValues(Family f) {
    updateId = f.id;
    updating = true;
    _nameController.text = f.providerName;
    _phoneController.text = f.providerPhone;
    _addressController.text = '${f.address}';
    rentCost = f.rentCost;
    cityId = f.cityID;
    housingType = f.housingType!;
    membersCount = f.membersCount;
    youngCount = f.youngersCount;
    _sharesCount = f.sharesCount;
    _otherOrgs.text = '${f.otherOrgs}';
    _notes.text = '${f.notes}';
    income = f.income;
    incomeType = f.incomeType!;
    familyType = f.type!;
    familyStatus = f.status!;
    providerSS = f.providerSS!;
    notifyListeners();
  }

  updateFamily(BuildContext context) async {
    Family family = getFamily();
    var response = await ApiBase().patch(
        url: "families/${family.id}",
        body: jsonEncode(family.toJson()),
        contentType: true);
    updating = false;
    if (context.mounted) Navigator.pop(context);
    notifyListeners();
  }

  disposeControllers() {
    updateId = null;
    _notes.dispose();
    _otherOrgs.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();

    rentCost = 0;
    cityId = null;
    housingType = HousingType.none;
    membersCount = 0;
    youngCount = 0;
    _sharesCount = null;
    income = 0;
    incomeType = IncomeType.none;
    familyType = FamilyType.none;
    familyStatus = FamilyStatus.none;
    providerSS = ProviderSS.none;

    updating = false;
    isLoading = true;
  }

  getSteps() {
    return <Step>[
      Step(
        title: SizedBox(),
        label: const Text('التواصل'),
        state: currentStep > 0 ? StepState.complete : StepState.disabled,
        isActive: currentStep >= 0,
        content: Form(
          key: firstFormKey,
          child: Column(
            children: [
              FamilyTextField(
                label: "إسم مسؤول العائلة",
                maxLength: 255,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "هذا الحقل مطلوب";
                  } else {
                    return null;
                  }
                },
                controller: _nameController,
                icon: const Icon(Icons.person_outline),
              ),
              FamilyTextField(
                label: "رقم الهاتف",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "هذا الحقل مطلوب";
                  } else {
                    return null;
                  }
                },
                maxLength: 255,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _phoneController,
                icon: const Icon(Icons.phone_enabled_outlined),
              ),
            ],
          ),
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        label: const Text("العنوان"),
        title: SizedBox(),
        content: Form(
          key: secondFormKey,
          child: Column(
            children: [
              CustomDropDownButton(
                items: cities.map((city) {
                  return DropdownMenuItem(
                    value: city.id,
                    child: Text(city.name!),
                  );
                }).toList(),
                value: cityId,
                labelText: 'المنطقة',
                onChanged: (id) {
                  cityId = id;
                  print(cityId);
                },
                icon: Icon(Icons.my_location),
              ),
              FamilyTextField(
                label: "عنوان السكن",
                maxLength: 500,
                controller: _addressController,
                icon: const Icon(Icons.place_outlined),
                maxLines: 2,
              ),
              CustomDropDownButton(
                icon: Icon(Icons.house_outlined),
                items: HousingType.values.map((incomeType) {
                  return DropdownMenuItem(
                    value: incomeType.number,
                    child: Text(incomeType.value),
                  );
                }).toList(),
                labelText: 'نوع السكن',
                value: housingType.number,
                onChanged: (value) {
                  housingType = HousingType.getType(value);
                  notifyListeners();
                },
              ),
              if (housingType == HousingType.rent)
                FamilyTextField(
                  initialValue: rentCost.toString(),
                  width: .4,
                  label: 'مبلغ الإيجار',
                  icon: const Icon(Icons.attach_money_outlined),
                  onChanged: (value) {
                    rentCost = int.tryParse(value);
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                )
            ],
          ),
        ),
      ),
      Step(
        label: const Text("تفاصيل العائلة"),
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: SizedBox(),
        content: Form(
          key: thirdFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FamilyTextField(
                        label: "عدد الافراد",
                        initialValue: membersCount.toString(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          membersCount = int.tryParse(value);
                        },
                        validator: (value) {
                          int? number = int.tryParse(value!);
                          if (number != null) {
                            if (number > 100) {
                              return 'عدد الافراد كبير جدا';
                            } else {
                              return null;
                            }
                          }

                          return null;
                        },
                        icon: const Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FamilyTextField(
                        label: "عدد القاصرين",
                        initialValue: youngCount.toString(),
                        onChanged: (value) {
                          youngCount = int.tryParse(value);
                        },
                        validator: (value) {
                          int? number = int.tryParse(value!);
                          if (number != null) {
                            if (number > 100) {
                              return 'عدد القاصرين كبير جدا';
                            } else {
                              return null;
                            }
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        icon: const Icon(Icons.child_care_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CustomDropDownButton(
                        items: ProviderSS.values.map((ss) {
                          return DropdownMenuItem(
                            value: ss.number,
                            child: Text(ss.value),
                          );
                        }).toList(),
                        value: providerSS.number,
                        icon: Icon(Icons.family_restroom_outlined),
                        labelText: 'الحالة الاجتماعية',
                        onChanged: (value) {
                          providerSS = ProviderSS.getSS(value);
                          print(providerSS.number);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomDropDownButton(
                        value: familyStatus.number,
                        items: FamilyStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status.number,
                            child: Text(status.value),
                          );
                        }).toList(),
                        labelText: 'الحالة المادية',
                        icon: Icon(Icons.bar_chart_outlined),
                        onChanged: (value) {
                          familyStatus = FamilyStatus.getStatus(value);
                          print(familyStatus.number);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              CustomDropDownButton(
                icon: Icon(Icons.family_restroom_outlined),
                value: familyType.number,
                items: FamilyType.values.map((type) {
                  return DropdownMenuItem(
                    value: type.number,
                    child: Text(type.value),
                  );
                }).toList(),
                labelText: 'نوع العائلة',
                onChanged: (value) {
                  familyType = FamilyType.getType(value);
                  print(familyType.number);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CustomDropDownButton(
                        value: incomeType.number,
                        items: IncomeType.values.map((incomeType) {
                          return DropdownMenuItem(
                            value: incomeType.number,
                            child: Text(incomeType.value),
                          );
                        }).toList(),
                        icon: Icon(Icons.money_outlined),
                        labelText: 'مصدر الدخل',
                        onChanged: (value) {
                          incomeType = IncomeType.getType(value);
                          print(incomeType.number);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FamilyTextField(
                        initialValue: income.toString(),
                        label: "مقدار الدخل",
                        onChanged: (value) {
                          income = int.tryParse(value);
                        },
                        icon: const Icon(Icons.attach_money_outlined),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              FamilyTextField(
                label: "منظمات اخرى",
                maxLines: 2,
                controller: _otherOrgs,
                icon: const Icon(Icons.location_city_outlined),
                maxLength: 1000,
              ),
              FamilyTextField(
                label: "ملاحظات",
                maxLines: 3,
                controller: _notes,
                maxLength: 1000,
                icon: const Icon(Icons.edit_note_outlined),
              ),
              CustomDropDownButton(
                value: _sharesCount,
                labelText: 'عدد الاسهم',
                icon: Icon(Icons.balance_outlined),
                onChanged: (value) {
                  _sharesCount = value;
                  print(_sharesCount);
                },
                items: List.generate(11, (index) => index)
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  onStepTapped(int step) {
    if (firstFormKey.currentState!.validate()) {
      currentStep = step;
      notifyListeners();
    }
  }

  onStepContinue(BuildContext context) async {
    switch (currentStep) {
      case 0:
        if (firstFormKey.currentState!.validate()) {
          getCities();
          currentStep += 1;
        }
        break;
      case 1:
        if (secondFormKey.currentState!.validate()) {
          currentStep += 1;
        }
        break;
      case 2:
        if (thirdFormKey.currentState!.validate()) {
          if (updating) {
            updateFamily(context);
          } else {
            postFamily(context);
          }
        }
    }
    notifyListeners();
  }

  onStepCancel(BuildContext context) {
    if (currentStep == 0) {
      Navigator.pop(context);
    } else {
      currentStep -= 1;
      notifyListeners();
    }
  }

  Family getFamily() {
    Family family = Family(
      id: updateId,
      providerName: _nameController.text,
      providerPhone: _phoneController.text,
      type: familyType,
      notes: _notes.text,
      address: _addressController.text,
      cityID: cityId,
      housingType: housingType,
      income: income,
      incomeType: incomeType,
      membersCount: membersCount,
      otherOrgs: _otherOrgs.text,
      providerSS: providerSS,
      rentCost: rentCost,
      youngersCount: youngCount,
      sharesCount: _sharesCount,
      status: familyStatus,
    );
    return family;
  }

  postFamily(BuildContext context) async {
    var response = await ApiBase().post(
        url: "families",
        body: jsonEncode(getFamily().toJson()),
        contentType: true);
    if (response != null && context.mounted) {
      Fluttertoast.showToast(
          msg: ' تم إضافة العائلة بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: ' حدث خطأ اثناء الاتصال بالخادم',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getCities() async {
    var response =
        await ApiBase().get(url: "cities", queryParameters: {"perPage": 50});
    List<dynamic> data = response["data"];
    cities = data.map((city) => City.fromJson(city)).toList();
    notifyListeners();
  }
}

class FamilyTextField extends StatelessWidget {
  const FamilyTextField(
      {super.key,
      required this.label,
      this.initialValue,
      this.width = 1,
      this.controller,
      this.validator,
      this.onChanged,
      this.icon,
      this.inputFormatters = const [],
      this.maxLength,
      this.maxLines});

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final double width;
  final String? Function(String?)? validator;
  final dynamic Function(String)? onChanged;
  final Icon? icon;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: Responsive.widthOfScreen(context: context, width: width),
        child: TextFormField(
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          keyboardType:
              inputFormatters!.contains(FilteringTextInputFormatter.digitsOnly)
                  ? TextInputType.number
                  : null,
          textDirection: TextDirection.rtl,
          maxLines: maxLines,
          decoration: InputDecoration(
            suffixIcon: icon,
            labelStyle: const TextStyle(fontSize: 20),
            errorMaxLines: 3,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Text(
              label,
              textDirection: TextDirection.rtl,
            ),
            border: const OutlineInputBorder(),
          ),
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          maxLength: maxLength,
        ),
      ),
    );
  }
}

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    this.icon,
    required this.items,
    required this.labelText,
    this.onChanged,
    this.value,
  });
  final int? value;
  final Function(int?)? onChanged;
  final Icon? icon;
  final List<DropdownMenuItem<int>> items;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField(
        icon: icon,
        items: items,
        menuMaxHeight: 300,
        onChanged: onChanged,
        value: value,
        iconSize: 20,
        borderRadius: BorderRadius.circular(12),
        style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontFamily: 'tajwal',
            overflow: TextOverflow.ellipsis),
        decoration: InputDecoration(
            label: Text(
              labelText,
              overflow: TextOverflow.ellipsis,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            floatingLabelStyle: const TextStyle(fontSize: 20),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            border: const OutlineInputBorder()),
      ),
    );
  }
}
