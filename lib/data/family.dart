import 'enums.dart';
import 'package:intl/intl.dart' as intl;

class Family {
  final int? id;
  final String providerName;
  final String providerPhone;
  final int? membersCount;
  final int? youngersCount;
  final int? cityID;
  final int? income;
  final int? rentCost;
  final int? sharesCount;
  final ProviderSS? providerSS;
  final FamilyStatus? status;
  final FamilyType? type;
  final String? address;
  final HousingType? housingType;
  final IncomeType? incomeType;
  final String? otherOrgs;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<dynamic>? documents;

  Family(
      {this.id,
      required this.providerName,
      required this.providerPhone,
      this.membersCount,
      this.youngersCount,
      this.providerSS,
      this.status,
      this.type,
      this.cityID,
      this.address,
      this.income,
      this.housingType,
      this.rentCost,
      this.sharesCount,
      this.incomeType,
      this.otherOrgs,
      this.notes,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.documents});

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json["id"],
      providerName: json["provider_name"],
      providerPhone: json["provider_phone"],
      membersCount: json["members_count"],
      youngersCount: json["youngers_count"],
      providerSS: ProviderSS.getSS(json["provider_social_status"]),
      status: FamilyStatus.getStatus(json["status"]),
      type: FamilyType.getType(json["type"]),
      cityID: json["city_id"],
      address: json["address"],
      income: json["income"],
      incomeType: IncomeType.getType(json["income_type"]),
      housingType: HousingType.getType(json["housing_type"]),
      sharesCount: json["shares_count"],
      notes: json["notes"],
      otherOrgs: json["other_orgs"],
      rentCost: json["rent_cost"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"] != null
          ? DateTime.parse(json["deleted_at"])
          : null,
      documents: json["docs"],
    );
  }

  Map toJson() => {
        'provider_name': providerName,
        'provider_phone': providerPhone,
        'members_count': membersCount,
        'youngers_count': youngersCount,
        'provider_social_status': providerSS?.toInt(),
        'type': type?.toInt(),
        'status': status?.toInt(),
        'city_id': cityID,
        'address': address,
        'income': income,
        'housing_type': housingType?.toInt(),
        'rent_cost': rentCost,
        'shares_count': sharesCount,
        'income_type': incomeType?.toInt(),
        'other_orgs': otherOrgs,
        'notes': notes,
        'docs': (documents == null) ? [] : documents
      };

  Map details() => {
        'المدينة': cityID,
        'العنوان': address,
        'نوع السكن': housingType?.value,
        'الايجار': rentCost,
        'حالة المسؤول الاجتماعية': providerSS?.value,
        'نوع العائلة': type?.value,
        'حالة العائلة': status?.value,
        'عدد الافراد': membersCount,
        'عدد القاصرين': youngersCount,
        'الراتب': income,
        'عدد الاسهم': sharesCount,
        'مصدر الراتب': incomeType?.value,
        'منظمات اخرى': otherOrgs,
        'ملاحظات': notes,
        'تاريخ الاضافة': intl.DateFormat.yMd().format(createdAt!),
        'اخر تحديث': (updatedAt == null)
            ? null
            : intl.DateFormat.yMd().format(updatedAt!),
        'تاريخ الحذف': (deletedAt == null)
            ? null
            : intl.DateFormat.yMd().format(deletedAt!),
        'مستندات': (documents == null) ? null : documents
      };
}
