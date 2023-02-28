class UserDTO {
  String? name;
  String? email;
  String? address;
  String? phone;
  String? education;
  String? birth;
  List<Experience>? experience;

  UserDTO(this.name, this.email, this.address, this.phone, this.education,
      this.birth, this.experience);

  UserDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    address = json['address'];
    phone = json['phone'];
    education = json['education'];
    birth = json['birth'];
    if (json['experience'] != null) {
      experience = <Experience>[];
      json['experience'].forEach((v) {
        experience!.add(new Experience.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['education'] = this.education;
    data['birth'] = this.birth;
    if (this.experience != null) {
      data['experience'] = this.experience!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Experience {
  String? company;
  String? position;
  String? duration;

  Experience(this.company, this.position, this.duration);

  Experience.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    position = json['position'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company;
    data['position'] = this.position;
    data['duration'] = this.duration;
    return data;
  }
}
