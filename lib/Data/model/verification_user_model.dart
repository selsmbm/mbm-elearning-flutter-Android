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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['orgName'] = orgName;
    data['orgId'] = orgId;
    data['position'] = position;
    data['time'] = time;
    return data;
  }
}
