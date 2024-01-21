class City {
  final int? id;
  final String? name;
  final int? familiesCount;

  City({this.id, this.name, this.familiesCount});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        id: json["id"],
        name: json["name"],
        familiesCount:
            (json["families_count"] == null) ? 0 : json["families_count"]);
  }

  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}
