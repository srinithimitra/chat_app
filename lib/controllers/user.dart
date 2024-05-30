import 'package:chat_app/models/user.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  UserModel user = UserModel(username: "", email: "");

  void setUser(UserModel user) {
    this.user = user;
    update();
  }
}
