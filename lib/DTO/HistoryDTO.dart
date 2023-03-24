class HistoryDTO {
  int? id;
  String? workerId;
  String? position;
  String? startDate;
  String? endDate;

  HistoryDTO(
      {this.id, this.workerId, this.position, this.startDate, this.endDate});

  HistoryDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workerId = json['workerId'];
    position = json['position'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['workerId'] = this.workerId;
    data['position'] = this.position;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => HistoryDTO.fromJson(map)).toList();
  }
}
