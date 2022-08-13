class TeachersModel {
  String? name;
  String? mobileNo;
  String? email;
  String? department;
  String? post;
  String? image;
  String? uG;
  String? pG;
  String? phd;
  String? dOB;

  TeachersModel(
      {this.name,
      this.mobileNo,
      this.email,
      this.department,
      this.post,
      this.image,
      this.uG,
      this.pG,
      this.phd,
      this.dOB});

  TeachersModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobile_no'].toString();
    email = json['email'];
    department = json['department'];
    post = json['post'];
    image = json['image'];
    uG = json['UG'];
    pG = json['PG'];
    phd = json['phd'];
    dOB = json['DOB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile_no'] = mobileNo;
    data['email'] = email;
    data['department'] = department;
    data['post'] = post;
    data['image'] = image;
    data['UG'] = uG;
    data['PG'] = pG;
    data['phd'] = phd;
    data['DOB'] = dOB;
    return data;
  }
}
