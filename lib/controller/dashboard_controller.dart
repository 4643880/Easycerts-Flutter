import 'package:get/get.dart';

class DashboardController extends GetxController implements GetxService {
  RxInt currentIndex = 1.obs;
  RxBool isLoading = false.obs;

  updateCurrentIndex(int value) {
    currentIndex.value = value;
    update();
  }

  updateIsLoading(bool value) {
    isLoading.value = value;
    update();
  }
}
