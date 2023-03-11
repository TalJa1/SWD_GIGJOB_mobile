class WorkerDTO {
  String? id;
  String? firstName;
  String? lastName;
  String? middleName;
  String? birthday;
  String? education;

  WorkerDTO(
      {this.id,
      this.firstName,
      this.lastName,
      this.middleName,
      this.birthday,
      this.education});

  WorkerDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    birthday = json['birthday'];
    education = json['education'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['birthday'] = this.birthday;
    data['education'] = this.education;
    return data;
  }
}
