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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['desc'] = desc;
    data['title'] = title;
    data['id'] = id;
    data['image'] = image;
    data['starttime'] = starttime;
    data['endtime'] = endtime;
    data['admin_org'] = adminOrg;
    data['admin_org_ids'] = adminOrgIds;
    data['website'] = website;
    return data;
  }
}
