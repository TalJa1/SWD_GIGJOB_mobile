class AccountDTO {
  String aud;
  String azp;
  String email;
  bool emailVerified;
  int exp;
  int iat;
  String iss;
  String sub;
  String name;
  String picture;
  String givenName;
  String locale;

  AccountDTO(
      { 
      required this.aud,
      required this.azp,
      required this.email,
      required this.emailVerified,
      required this.exp,
      required this.iat,
      required this.iss,
      required this.sub,
      required this.name,
      required this.picture,
      required this.givenName,
      required this.locale});

  factory AccountDTO.fromJson(Map<String, dynamic> json) => AccountDTO(
    aud: json['aud'],
    azp: json['azp'],
    email: json['email'],
    emailVerified: json['email_verified'],
    exp: json['exp'],
    iat: json['iat'],
    iss: json['iss'],
    sub: json['sub'],
    name: json['name'],
    picture: json['picture'],
    givenName: json['given_name'],
    locale: json['locale']
  );
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aud'] = this.aud;
    data['azp'] = this.azp;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['exp'] = this.exp;
    data['iat'] = this.iat;
    data['iss'] = this.iss;
    data['sub'] = this.sub;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['given_name'] = this.givenName;
    data['locale'] = this.locale;
    return data;
  }
}