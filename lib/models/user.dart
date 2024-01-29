class UserInfo {
  final String email;
  final String password;

  UserInfo({
    required this.email,
    required this.password,

  });

  Map<String, dynamic> getUserInfoMap() {
    return {
      "email": email,
      "password": password,
 
    };
  }
}