import 'package:get/get.dart';
import 'load_status.dart';

// Base controller that standardises async loading/error/empty/success state.

/* 
Use 'runGuarded' inside any GetX controller to wrap a Future call. 
It will:
- set 'status' to loading
- run the action
- mark success / empty / error appropriately
- keep 'errorMessage' up to date
*/ 

abstract class BaseController extends GetxController {
  final Rx<LoadStatus> status = LoadStatus.idle.obs;
  final RxString errorMessage = ''.obs;

  bool get isLoading => status.value.isLoading;

  Future<T?> runGuarded<T>(
    Future<T> Function() action, {
    bool Function(T result)? isEmpty,
    void Function(Object error)? onError,
  }) async {
    try {
      status.value = LoadStatus.loading;
      errorMessage.value = '';
      final result = await action();
      if (isEmpty != null && isEmpty(result)) {
        status.value = LoadStatus.empty;
      } else {
        status.value = LoadStatus.success;
      }
      return result;
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = LoadStatus.error;
      if (onError != null) onError(e);
      return null;
    }
  }
}
