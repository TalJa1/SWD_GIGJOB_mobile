class ApplyJobDTO {
  String? workerId;
  Job? job;
  String? status;

  ApplyJobDTO({this.workerId, this.job, this.status});

  ApplyJobDTO.fromJson(Map<String, dynamic> json) {
    workerId = json['workerId'];
    job = json['job'] != null ? new Job.fromJson(json['job']) : null;
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

  Shop({this.id, this.name, this.description, this.accountId});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    accountId = json['accountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['accountId'] = this.accountId;
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
}
