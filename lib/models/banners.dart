class BannersModel {
  int id;
  String banner;
  String photo;

  BannersModel({this.id, this.banner, this.photo});
  BannersModel.fromJson(Map json) {
    id = json['_id'];
    banner = json['banner'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['banner'] = this.banner;
    data['photo'] = this.photo;
    return data;
  }
}
