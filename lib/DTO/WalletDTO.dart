import 'dart:ffi';

class WalletDTO {
  String? name;
  String? purpose;
  String? id;
  double? balance;
  String? accountId;

  WalletDTO(this.name, this.purpose, this.id, this.balance, this.accountId);

  WalletDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    purpose = json['purpose'];
    id = json['id'];
    balance = json['balance'];
    accountId = json['accountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['purpose'] = this.purpose;
    data['id'] = this.id;
    data['balance'] = this.balance;
    data['accountId'] = this.accountId;
    return data;
  }
}
