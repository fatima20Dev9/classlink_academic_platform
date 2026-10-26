class EnrollmentModel {
  final String id;
  final String studentId;
  final String courseOfferingId;

  const EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseOfferingId,
  });

  factory EnrollmentModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return EnrollmentModel(
      id: docId,
      studentId: json['studentId'] ?? '',
      courseOfferingId: json['courseOfferingId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'courseOfferingId': courseOfferingId,
    };
  }

  EnrollmentModel copyWith({
    String? id,
    String? studentId,
    String? courseOfferingId,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
    );
  }
}
