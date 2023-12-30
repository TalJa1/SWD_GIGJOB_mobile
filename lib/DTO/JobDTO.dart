import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';

class JobDTO {
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
  int? salary;

  JobDTO(
      {this.id,
      this.shop,
      this.jobType,
      this.title,
      this.description,
      this.skill,
      this.benefit,
      this.createdDate,
      this.updatedDate,
      this.expiredDate,
      this.salary});

  JobDTO.fromJson(Map<String, dynamic> json) {
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
    salary = json['salary'];
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
    data['salary'] = this.salary;
    return data;
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => JobDTO.fromJson(map)).toList();
  }
}
