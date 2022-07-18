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
    data['id'] = this.id;
    data['title'] = this.title;
    data['posttime'] = this.posttime;
    data['description'] = this.description;
    data['event'] = this.event;
    data['org'] = this.org;
    data['url'] = this.url;
    data['orgid'] = this.orgid;
    data['eventid'] = this.eventid;
    data['uploaded_by_user'] = this.uploadedByUser;
    data['uploaded_by_user_uid'] = this.uploadedByUserUid;
    return data;
  }
}
