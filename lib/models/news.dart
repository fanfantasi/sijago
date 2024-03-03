class NewsModel {
  String id;
  String link;
  int like;
  String itemid;
  bool isliked = false;

  NewsModel({this.id, this.link, this.like, this.itemid, this.isliked});
  NewsModel.fromJson(Map json) {
    id = json['id'];
    link = json['link'];
    like = json['like'];
    itemid = json['itemid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['link'] = this.link;
    data['like'] = this.like;
    data['itemid'] = this.itemid;
    return data;
  }
}
