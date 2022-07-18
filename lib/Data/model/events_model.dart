class EventsModel {
  String? desc;
  String? title;
  int? id;
  String? image;
  String? adminsMap;
  String? admins;
  String? tagline;
  String? type;
  String? website;

  EventsModel(
      {this.desc,
      this.title,
      this.id,
      this.image,
      this.adminsMap,
      this.admins,
      this.tagline,
      this.type,
      this.website});

  EventsModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    title = json['title'];
    id = json['id'];
    image = json['image'];
    adminsMap = json['admins_map'];
    admins = json['admins'];
    tagline = json['tagline'];
    type = json['type'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['desc'] = this.desc;
    data['title'] = this.title;
    data['id'] = this.id;
    data['image'] = this.image;
    data['admins_map'] = this.adminsMap;
    data['admins'] = this.admins;
    data['tagline'] = this.tagline;
    data['type'] = this.type;
    data['website'] = this.website;
    return data;
  }
}
