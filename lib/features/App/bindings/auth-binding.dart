import 'package:get/get.dart';
import 'package:parcking_slot_booking/features/Auth/controllers/auth_controller.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
