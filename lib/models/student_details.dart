class Student {
  int? id;
  String name;
  int mobileNumber;
  String password;

  Student({this.id, required this.name, required this.mobileNumber, required this.password});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'password': password,
    };
  }


  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      mobileNumber: map['mobileNumber'],
      password: map['password'],
    );
  }
}
