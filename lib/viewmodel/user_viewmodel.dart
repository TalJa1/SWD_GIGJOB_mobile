class UserModel {
  String email = "";
  String education = "";
  String major = "";
  int age = 0;
  String address = "";
  String phone = "";

  UserModel({
    required this.email,
    required this.education,
    required this.major,
    required this.age,
    required this.address,
    required this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    education = json['education'];
    major = json['major'];
    age = json['age'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['education'] = education;
    _data['major'] = major;
    _data['age'] = age;
    _data['address'] = address;
    _data['phone'] = phone;
    return _data;
  }
}
