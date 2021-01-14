import 'package:get/get.dart';
import 'package:hostelfinder/loginpages/logincontrollers/signincontroller.dart';

class PageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignInController>(SignInController());
  }
}
