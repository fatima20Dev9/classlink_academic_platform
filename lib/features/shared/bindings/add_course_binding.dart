import 'package:get/get.dart';
import '../controllers/add_course_controller.dart';

class AddCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCourseController>(
      () => AddCourseController(),
    );
  }
}