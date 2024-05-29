import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  UserModel convertFromMap(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'],
      email: data['email'],
      id: data['id'],
    );
  }

  Future<void> signInWithUsernameandPassword({
    required String username,
    required String password,
  }) async {
    await users
        .where("username", isEqualTo: username)
        .get()
        .then((querySnapshot) {
      var fetchedUser = querySnapshot.docs.map((doc) => doc.data()).toList();

      if (fetchedUser.isEmpty) {
        logger.i("$username not found");
      } else {
        UserModel user =
            convertFromMap(fetchedUser.first as Map<String, dynamic>);
        logger.d("User found: $user");

        // Sign in with email and password
        _firebaseAuth
            .signInWithEmailAndPassword(
          email: user.email,
          password: password,
        )
            .then((value) {
          logger.i("User signed in: $value");
          // set user as logged in
          user.setIsLoggedIn(true);
          // store user data using getx
          Get.find<UserController>().user = user;
        }).catchError((error) {
          logger.e("Failed to sign in: $error");
        });
      }
    });
  }

  Future<void> signUpWithEmailandPassword({
    required UserModel user,
    required String password,
  }) async {}

  Future<void> signUpWithGoogle(UserModel user) async {}

  Future<void> signUpWithFacebook(UserModel user) async {}

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    // set user as logged out
    Get.find<UserController>().user.setIsLoggedIn(false);
  }
}

class UserController extends GetxController {
  UserModel user = UserModel(username: "", email: "");

  void setUser(UserModel user) {
    this.user = user;
    update();
  }
}
