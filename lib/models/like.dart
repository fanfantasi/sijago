class LikeModel {
  int id;
  int like;

  LikeModel({this.id, this.like});
  LikeModel.fromJson(Map json) {
    id = json['id'];
    like = json['newsid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['newsid'] = this.like;
    return data;
  }
}
