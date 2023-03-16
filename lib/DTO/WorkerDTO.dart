class WorkerDTO {
  String? accountId;
  String? id;
  String? firstName;
  String? lastName;
  String? middleName;
  String? birthday;
  String? education;
  String? email;
  String? phone;
  String? username;
  String? password;
  String? imageUrl;

  WorkerDTO(
      {this.accountId,
      this.id,
      this.firstName,
      this.lastName,
      this.middleName,
      this.birthday,
      this.education,
      this.email,
      this.phone,
      this.username,
      this.password,
      this.imageUrl});

  WorkerDTO.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    birthday = json['birthday'];
    education = json['education'];
    email = json['email'];
    phone = json['phone'];
    username = json['username'];
    password = json['password'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['birthday'] = this.birthday;
    data['education'] = this.education;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['password'] = this.password;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
