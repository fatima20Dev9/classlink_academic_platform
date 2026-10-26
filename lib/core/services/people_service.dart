import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<List<Map<String, dynamic>>> getCoursePeople(
  String courseOfferingId,
) async {
  final enrollmentsSnap = await _firestore
      .collection('enrollments')
      .where('courseOfferingId', isEqualTo: courseOfferingId)
      .get();

  final studentIds =
      enrollmentsSnap.docs.map((e) => e['studentId']).toList();

  if (studentIds.isEmpty) return [];

  List<Map<String, dynamic>> result = [];

  for (var i = 0; i < studentIds.length; i += 10) {
    final batch = studentIds.skip(i).take(10).toList();

    final snap = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: batch)
        .get();

    result.addAll(
      snap.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return data;
      }),
    );
  }

  return result;
}
}