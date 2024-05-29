class UserModel {
  String? id;
  String email;
  String username;
  String? profilePic;
  bool isLoggedIn = false;
  UserModel({
    required this.username,
    required this.email,
    this.profilePic,
    this.id,
  });

  String getUsername() => username;
  String getEmail() => email;
  String? getProfilePic() => profilePic;
  bool getIsLoggedIn() => isLoggedIn;

  void setIsLoggedIn(bool isLoggedIn) => this.isLoggedIn = isLoggedIn;
}
