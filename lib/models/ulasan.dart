class UlasanItemModel {
  String id;
  String customer;
  String avatar;
  int rating;
  String remarks;
  String date;

  UlasanItemModel(
      {this.id,
      this.customer,
      this.avatar,
      this.rating,
      this.remarks,
      this.date});
  UlasanItemModel.fromJson(Map json) {
    id = json['id'];
    customer = json['customer'];
    avatar = json['avatar'];
    rating = json['rating'];
    remarks = json['remarks'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['avatar'] = this.avatar;
    data['rating'] = this.rating;
    data['remarks'] = this.remarks;
    data['date'] = this.date;
    return data;
  }
}
