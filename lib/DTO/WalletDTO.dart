class WalletDTO {
  String? name;
  String? purpose;

  WalletDTO(this.name, this.purpose);

  WalletDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['purpose'] = this.purpose;
    return data;
  }
}
