class Login {
  int? id;
  String loginId;
  String password;
  bool isAdmin;

  Login({this.id, required this.loginId, required this.password, required this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loginId': loginId,
      'password': password,
      'isAdmin': isAdmin ? 1 : 0,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      id: map['id'],
      loginId: map['loginId'],
      password: map['password'],
      isAdmin: map['isAdmin'] == 1,
    );
  }
}
