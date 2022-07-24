class MBMStoryModel {
  int? id;
  String? date;
  String? link;
  String? title;
  String? content;
  String? excerpt;

  MBMStoryModel({
    this.id,
    this.date,
    this.link,
    this.title,
    this.content,
    this.excerpt,
  });

  MBMStoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    link = json['link'];
    title = json['title']['rendered'];
    content = json['content']['rendered'];
    excerpt = json['excerpt']['rendered'];
  }
}
