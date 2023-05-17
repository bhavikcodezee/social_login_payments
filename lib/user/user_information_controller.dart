import 'package:get/get.dart';
import 'package:social_login_payment/home/home_controller.dart';

class UserInformationController extends GetxController {
  HomeController homeController = Get.find<HomeController>();
  Future<void> logout() async {
    if (Get.arguments['type'] == "google") {
      await homeController.handleGoogleSignOut();
      Get.back();
    } else if (Get.arguments['type'] == "facebook") {
      await homeController.faceBookLogout();
      Get.back();
    } else if (Get.arguments['type'] == "linkdin") {
      homeController.linkdlnlogoutUser.value = true;
      Get.back();
    } else if (Get.arguments['type'] == "github") {
      homeController.gitHublogoutUser.value = true;
      Get.back();
    } else if (Get.arguments['type'] == "twitter") {
      Get.back();
    }
  }
}
