import 'package:gigjob_mobile/DTO/JobDTO.dart';

class ApplyJobDTO {
  String? workerId;
  JobDTO? job;
  String? status;

  ApplyJobDTO({this.workerId, this.job, this.status});

  ApplyJobDTO.fromJson(Map<String, dynamic> json) {
    workerId = json['workerId'];
    job = json['job'] != null ? new JobDTO.fromJson(json['job']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workerId'] = this.workerId;
    if (this.job != null) {
      data['job'] = this.job!.toJson();
    }
    data['status'] = this.status;
    return data;
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => ApplyJobDTO.fromJson(map)).toList();
  }
}

class Job {
  int? id;
  Shop? shop;
  JobType? jobType;
  String? title;
  String? description;
  String? skill;
  String? benefit;
  String? createdDate;
  String? updatedDate;
  String? expiredDate;

  Job(
      {this.id,
      this.shop,
      this.jobType,
      this.title,
      this.description,
      this.skill,
      this.benefit,
      this.createdDate,
      this.updatedDate,
      this.expiredDate});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    jobType =
        json['jobType'] != null ? new JobType.fromJson(json['jobType']) : null;
    title = json['title'];
    description = json['description'];
    skill = json['skill'];
    benefit = json['benefit'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    expiredDate = json['expiredDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.jobType != null) {
      data['jobType'] = this.jobType!.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['skill'] = this.skill;
    data['benefit'] = this.benefit;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['expiredDate'] = this.expiredDate;
    return data;
  }
}

class Shop {
  String? id;
  String? name;
  String? description;
  String? accountId;
  List<Addresses>? addresses;
  Account? account;


  Shop({this.id, this.name, this.description, this.accountId, this.addresses, this.account});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    accountId = json['accountId'];
    account =
        json['account'] != null ? new Account.fromJson(json['account']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['accountId'] = this.accountId;
    if (this.account != null) {
      data['account'] = this.account!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Account {
  String? id;
  String? username;
  String? email;
  String? phone;
  String? createdDate;
  String? updatedDate;
  String? role;
  bool? locked;
  bool? disable;

  Account(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.createdDate,
      this.updatedDate,
      this.role,
      this.locked,
      this.disable});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    role = json['role'];
    locked = json['locked'];
    disable = json['disable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['role'] = this.role;
    data['locked'] = this.locked;
    data['disable'] = this.disable;
    return data;
  }
}

class Addresses {
  int? id;
  String? street;
  String? district;
  String? city;
  String? province;
  String? country;

  String getAddress() {
    String fullAddress = '${street ?? ""}, ${district ?? ""}, ${city ?? ""}, ${country ?? ""}';

    return fullAddress;
  }

  Addresses(
      {this.id,
      this.street,
      this.district,
      this.city,
      this.province,
      this.country});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    street = json['street'];
    district = json['district'];
    city = json['city'];
    province = json['province'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['street'] = this.street;
    data['district'] = this.district;
    data['city'] = this.city;
    data['province'] = this.province;
    data['country'] = this.country;
    return data;
  }
}


class JobType {
  int? id;
  String? name;

  JobType({this.id, this.name});

  JobType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => JobType.fromJson(map)).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobType &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
