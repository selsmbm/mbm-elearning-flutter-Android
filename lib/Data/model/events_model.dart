class EventsModel {
  String? desc;
  String? title;
  int? id;
  String? image;
  String? starttime;
  String? endtime;
  String? adminOrg;
  String? adminOrgIds;
  String? website;

  EventsModel(
      {this.desc,
      this.title,
      this.id,
      this.image,
      this.starttime,
      this.endtime,
      this.adminOrg,
      this.adminOrgIds,
      this.website});

  EventsModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    title = json['title'];
    id = json['id'];
    image = json['image'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    adminOrg = json['admin_org'];
    adminOrgIds = json['admin_org_ids'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['title'] = this.title;
    data['id'] = this.id;
    data['image'] = this.image;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['admin_org'] = this.adminOrg;
    data['admin_org_ids'] = this.adminOrgIds;
    data['website'] = this.website;
    return data;
  }
}
