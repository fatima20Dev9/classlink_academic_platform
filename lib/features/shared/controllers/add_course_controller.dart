import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/course_offering_model.dart';
import '../../../models/course_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/course_repository.dart';
import '../../../repositories/course_offering_repository.dart';
import '../controllers/home_controller.dart';
import '../controllers/enrolled_courses_controller.dart';
import '../controllers/course_offering_controller.dart';
import '../../../../features/auth/controllers/session_controller.dart';

class AddCourseController extends GetxController {
  /// =========================
  /// REPOSITORIES
  /// =========================
  final CourseRepository _courseRepository = Get.find<CourseRepository>();

  final CourseOfferingRepository _offeringRepository =
      Get.find<CourseOfferingRepository>();

  final ChatRepository _chatRepository = Get.find<ChatRepository>();

  /// =========================
  /// SESSION
  /// =========================
  final SessionController _session = Get.find<SessionController>();

  /// =========================
  /// FORM KEY
  /// =========================
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// =========================
  /// LOADING
  /// =========================
  final RxBool isLoading = false.obs;

  /// =========================
  /// EDIT MODE
  /// =========================
  CourseModel? _editingCourse;
  CourseOfferingModel? _editingOffering;

  bool get isEditMode => _editingOffering != null && _editingCourse != null;

  String get submitLabel => isEditMode ? 'Update Course' : 'Create Course';
  String get pageTitle =>
      isEditMode ? 'Edit Course' : 'Add New Course';

  /// =========================
  /// REACTIVE FIELDS
  /// =========================
  final RxString courseName = ''.obs;
  final RxString instructorName = ''.obs;
  final RxString semester = ''.obs;
  final RxInt credits = 0.obs;

  final RxString overview = ''.obs;
  final RxString dayTime = ''.obs;

  final RxInt lectures = 0.obs;
  final RxInt hoursPerWeek = 0.obs;

  final RxInt attendance = 0.obs;
  final RxInt assignments = 0.obs;
  final RxInt midterm = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _hydrateFromArguments();
  }

  void _hydrateFromArguments() {
    final args = Get.arguments;
    if (args is Map) {
      final course = args['course'];
      final offering = args['offering'];
      if (course is CourseModel && offering is CourseOfferingModel) {
        _editingCourse = course;
        _editingOffering = offering;

        courseName.value = course.name;
        overview.value = course.overview;
        credits.value = course.credits;

        instructorName.value = offering.instructorName;
        semester.value = offering.semester;
        dayTime.value = offering.dayTime;
        lectures.value = offering.lectures;
        hoursPerWeek.value = offering.hoursPerWeek;
        attendance.value = offering.attendance;
        assignments.value = offering.assignments;
        midterm.value = offering.midterm;
      }
    }
  }

  /// =========================
  /// VALIDATION
  /// =========================
  bool get isFormValid =>
      courseName.value.trim().isNotEmpty &&
      instructorName.value.trim().isNotEmpty &&
      semester.value.trim().isNotEmpty &&
      credits.value > 0;

  /// =========================
  /// SUBMIT
  /// =========================
  Future<void> submit() async {
    try {
      final form = formKey.currentState;
      if (form != null) {
        if (!form.validate()) return;
        form.save();
      }

      if (!isFormValid) {
        Get.snackbar(
          'Error',
          'Please fill required fields',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;

      if (isEditMode) {
        await _updateExisting();
      } else {
        await _createNew();
      }

      // Refresh listings so the UI reflects the change.
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().refreshCourses();
      }
      if (Get.isRegistered<EnrolledCoursesController>()) {
        await Get.find<EnrolledCoursesController>().refreshCourses();
      }
      if (Get.isRegistered<CourseOfferingController>()) {
        await Get.find<CourseOfferingController>().loadInstructorOfferings();
      }

      Get.back();
      Get.snackbar(
        'Success',
        isEditMode
            ? 'Course updated successfully'
            : 'Course created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createNew() async {
    final userId = _session.uid;

    final courseData = {
      'name': courseName.value.trim(),
      'overview': overview.value.trim(),
      'credits': credits.value,
      'color': 4280163147,
      'createdAt': DateTime.now(),
    };

    final String courseId = await _courseRepository.add(courseData);

    final offeringData = {
      'courseId': courseId,
      'instructorId': userId,
      'instructorName': instructorName.value.trim(),
      'semester': semester.value.trim(),
      'inviteCode': await _offeringRepository.generateUniqueInviteCode(),
      'dayTime': dayTime.value.trim(),
      'lectures': lectures.value,
      'hoursPerWeek': hoursPerWeek.value,
      'attendance': attendance.value,
      'assignments': assignments.value,
      'midterm': midterm.value,
      'progress': 0,
      'createdAt': DateTime.now(),
    };

    final offeringId = await _offeringRepository.add(offeringData);

    // Auto-create the group chat for this course offering with the
    // instructor as the first member. Students get added automatically
    // on enrollment via EnrollmentService.
    try {
      await _chatRepository.createGroupChatForOffering(
        courseOfferingId: offeringId,
        groupName: courseName.value.trim(),
        memberIds: [userId],
      );
    } catch (_) {
      // chat creation must not block course creation
    }
  }

  Future<void> _updateExisting() async {
    final course = _editingCourse!;
    final offering = _editingOffering!;

    await _courseRepository.update(course.id, {
      'name': courseName.value.trim(),
      'overview': overview.value.trim(),
      'credits': credits.value,
    });

    await _offeringRepository.update(offering.id, {
      'instructorName': instructorName.value.trim(),
      'semester': semester.value.trim(),
      'dayTime': dayTime.value.trim(),
      'lectures': lectures.value,
      'hoursPerWeek': hoursPerWeek.value,
      'attendance': attendance.value,
      'assignments': assignments.value,
      'midterm': midterm.value,
    });

    // Keep group chat name in sync with the course name.
    try {
      await _chatRepository.createGroupChatForOffering(
        courseOfferingId: offering.id,
        groupName: courseName.value.trim(),
        memberIds: [offering.instructorId],
      );
    } catch (_) {}
  }
}
