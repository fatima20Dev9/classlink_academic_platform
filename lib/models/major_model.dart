class MajorModel {
  final String id;
  final String collegeId;
  final String name;

  MajorModel({
    required this.id,
    required this.collegeId,
    required this.name,
  });

  factory MajorModel.fromJson(Map<String, dynamic> json, String docId) {
    return MajorModel(
      id: docId,
      collegeId: json['collegeId'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collegeId': collegeId,
      'name': name,
    };
  }

  MajorModel copyWith({
    String? id,
    String? collegeId,
    String? name,
  }) {
    return MajorModel(
      id: id ?? this.id,
      collegeId: collegeId ?? this.collegeId,
      name: name ?? this.name,
    );
  }
}
