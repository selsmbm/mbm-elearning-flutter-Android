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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile_no'] = this.mobileNo;
    data['email'] = this.email;
    data['department'] = this.department;
    data['post'] = this.post;
    data['image'] = this.image;
    data['UG'] = this.uG;
    data['PG'] = this.pG;
    data['phd'] = this.phd;
    data['DOB'] = this.dOB;
    return data;
  }
}
