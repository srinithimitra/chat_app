import 'package:chat_app/controllers/user.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
  }) async {
    // Sign up with email and password
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    logger.i("User signed up: $userCredential");

    // save the user to firestore
    await users.add({
      'id': userCredential.user!.uid,
      'username': user.username,
      'email': user.email,
    }).then((value) {
      logger.i("User added to firestore: $value");
      // set user as logged in
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        username: user.username,
        email: user.email,
      );
      newUser.setIsLoggedIn(true);
      // store user data using getx
      Get.find<UserController>().user = newUser;
    }).catchError((error) {
      logger.e("Failed to add user to firestore: $error");
    });
  }

  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        logger.d("User signed up with Google: ${userCredential.user}");

        // save the user to firestore
        await users.add({
          'id': userCredential.user!.uid,
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'profilePic': userCredential.user!.photoURL,
        }).then((value) {
          logger.i("User added to firestore: $value");
          // set user as logged in
          UserModel newUser = UserModel(
            id: userCredential.user!.uid,
            username: userCredential.user!.displayName.toString(),
            email: userCredential.user!.email.toString(),
          );
          newUser.setIsLoggedIn(true);
          // store user data using getx
          Get.find<UserController>().user = newUser;
        }).catchError((error) {
          logger.e("Failed to add user to firestore: $error");
        });
      }
    } on FirebaseAuthException catch (e) {
      logger.e("Failed to sign in with Google: $e");
    }
  }

  Future<void> signUpWithFacebook(UserModel user) async {}

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    // set user as logged out
    Get.find<UserController>().user.setIsLoggedIn(false);
  }
}

