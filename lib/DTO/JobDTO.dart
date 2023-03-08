class JobDTO {
  int? id;
  String? shopId;
  int? jobTypeId;
  String? title;
  String? description;
  String? skill;
  String? benefit;
  String? createdDate;
  String? updatedDate;
  String? expiredDate;

  JobDTO(
      {this.id,
      this.shopId,
      this.jobTypeId,
      this.title,
      this.description,
      this.skill,
      this.benefit,
      this.createdDate,
      this.updatedDate,
      this.expiredDate});

  JobDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    jobTypeId = json['jobTypeId'];
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
    data['shopId'] = this.shopId;
    data['jobTypeId'] = this.jobTypeId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['skill'] = this.skill;
    data['benefit'] = this.benefit;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['expiredDate'] = this.expiredDate;
    return data;
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => JobDTO.fromJson(map)).toList();
  }
}
