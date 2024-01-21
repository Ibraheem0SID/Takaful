enum UserRole {
  superAdmin(1, 'Super Admin'),
  readWrite(2, 'Editor'),
  readOnly(3, 'Read Only');

  final int number;
  final String value;

  const UserRole(this.number, this.value);

  static UserRole getUserRole(int? number) =>
      UserRole.values.firstWhere((role) => role.number == number,
          orElse: () => UserRole.readOnly);

  int toInt() => number;
}

//Provider Social Status
enum ProviderSS {
  none(null, "لا يوجد"),
  widow(1, 'ارملة'),
  divorced(2, 'مطلقة'),
  married(3, 'متزوجة'),
  specialNeeds(4, 'احتياجات خاصة'),
  missing(5, 'الزوج مفقود'),
  hanging(6, 'معلقة');

  final int? number;
  final String value;
  const ProviderSS(this.number, this.value);

  static ProviderSS getSS(int? number) => ProviderSS.values
      .firstWhere((ss) => ss.number == number, orElse: () => none);

  int? toInt() => number;
}

enum FamilyType {
  none(null, "لا يوجد"),
  specialNeeds(1, 'مرضى'),
  orphans(2, 'ايتام'),
  chase(3, 'متعففين'),
  missing(4, 'مفقود م'),
  noProvider(5, 'بلا معيل'),
  others(6, 'اخرى');

  final int? number;
  final String value;
  const FamilyType(this.number, this.value);

  static FamilyType getType(int? number) => FamilyType.values
      .firstWhere((type) => type.number == number, orElse: () => none);

  int? toInt() => number;
}

enum IncomeType {
  none(null, "لا يوجد"),
  martyrs(1, 'شهيد'),
  retired(2, 'تقاعد'),
  aid(3, 'رعاية'),
  others(4, 'اخرى');

  final int? number;
  final String value;
  const IncomeType(this.number, this.value);

  static IncomeType getType(int? number) => IncomeType.values
      .firstWhere((type) => type.number == number, orElse: () => none);

  int? toInt() => number;
}

enum HousingType {
  none(null, "لا يوجد"),
  rent(1, 'إيجار'),
  ownership(2, 'ملك'),
  illegal(3, 'تجاوز'),
  others(4, 'اخرى');

  final int? number;
  final String value;
  const HousingType(this.number, this.value);

  static HousingType getType(int? number) => HousingType.values
      .firstWhere((type) => type.number == number, orElse: () => none);

  int? toInt() => number;
}

enum FamilyStatus {
  none(null, "لا يوجد"),
  veryWeak(1, 'ضعيف جدا'),
  weak(2, 'ضعيف'),
  average(3, 'متوسط');

  final int? number;
  final String value;
  const FamilyStatus(this.number, this.value);

  static FamilyStatus getStatus(int? number) => FamilyStatus.values
      .firstWhere((status) => status.number == number, orElse: () => none);

  int? toInt() => number;
}
