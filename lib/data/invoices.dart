class Invoice {
  final int? id;
  final DateTime? dateTime;
  final int? amount;
  final String? description;
  final int? familyId;
  final int? userId;

  Invoice(
      {this.id,
      this.dateTime,
      this.amount,
      this.description,
      this.familyId,
      this.userId});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        id: json["id"],
        dateTime: DateTime.parse(json["date"]),
        amount: json["amount"],
        familyId: json["family_id"],
        userId: json["user_id"],
        description: json["description"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["date"] = dateTime.toString();
    data["amount"] = amount.toString();
    data["description"] = description.toString();
    data["family_id"] = familyId.toString();
    data["user_id"] = userId.toString();
    return data;
  }
}
