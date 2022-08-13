class UsefulLinksModel {
  String? desc;
  String? title;
  int? id;
  String? url;
  String? image;
  String? type;

  UsefulLinksModel(
      {this.desc, this.title, this.id, this.url, this.image, this.type});

  UsefulLinksModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    title = json['title'];
    id = json['id'];
    url = json['url'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['desc'] = desc;
    data['title'] = title;
    data['id'] = id;
    data['url'] = url;
    data['image'] = image;
    data['type'] = type;
    return data;
  }
}
