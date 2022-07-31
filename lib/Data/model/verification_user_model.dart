class VerificationUserModel {
  int? id;
  String? userId;
  String? name;
  String? email;
  String? mobile;
  String? orgName;
  String? orgId;
  String? position;
  String? time;

  VerificationUserModel(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.mobile,
      this.orgName,
      this.orgId,
      this.position,
      this.time});

  VerificationUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'].toString();
    orgName = json['orgName'];
    orgId = json['orgId'].toString();
    position = json['position'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['orgName'] = this.orgName;
    data['orgId'] = this.orgId;
    data['position'] = this.position;
    data['time'] = this.time;
    return data;
  }
}
