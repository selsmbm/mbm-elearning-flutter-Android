class BlogModel {
  int? id;
  String? title;
  String? posttime;
  String? description;
  String? event;
  String? org;
  String? url;
  String? orgid;
  String? eventid;
  String? uploadedByUser;
  String? uploadedByUserUid;

  BlogModel(
      {this.id,
      this.title,
      this.posttime,
      this.description,
      this.event,
      this.org,
      this.url,
      this.orgid,
      this.eventid,
      this.uploadedByUser,
      this.uploadedByUserUid});

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    posttime = json['posttime'];
    description = json['description'];
    event = json['event'];
    org = json['org'];
    url = json['url'];
    orgid = json['orgid'];
    eventid = json['eventid'];
    uploadedByUser = json['uploaded_by_user'];
    uploadedByUserUid = json['uploaded_by_user_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['posttime'] = posttime;
    data['description'] = description;
    data['event'] = event;
    data['org'] = org;
    data['url'] = url;
    data['orgid'] = orgid;
    data['eventid'] = eventid;
    data['uploaded_by_user'] = uploadedByUser;
    data['uploaded_by_user_uid'] = uploadedByUserUid;
    return data;
  }
}
