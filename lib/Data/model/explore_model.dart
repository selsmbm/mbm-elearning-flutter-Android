class ExploreModel {
  String? desc;
  String? title;
  int? id;
  String? image;
  String? adminsMap;
  String? admins;
  String? tagline;
  String? type;
  String? website;
  String? events;
  int? follow;

  ExploreModel(
      {this.desc,
      this.title,
      this.id,
      this.image,
      this.adminsMap,
      this.admins,
      this.tagline,
      this.type,
      this.website,
      this.events,
      this.follow});

  ExploreModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    title = json['title'];
    id = json['id'];
    image = json['image'];
    adminsMap = json['admins_map'];
    admins = json['admins'];
    tagline = json['tagline'];
    type = json['type'];
    website = json['website'];
    events = json['events'];
    follow = json['follow'];
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
    data['events'] = this.events;
    data['follow'] = this.follow;
    return data;
  }
}
