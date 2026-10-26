class CollegeModel {
  final String id;
  final String name;

  CollegeModel({
    required this.id,
    required this.name,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json, String docId) {
    return CollegeModel(
      id: docId,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  CollegeModel copyWith({
    String? id,
    String? name,
  }) {
    return CollegeModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}