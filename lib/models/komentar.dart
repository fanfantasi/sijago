class ModelComment {
  String id;
  String customer;
  String avatar;
  String comment;
  String created;

  ModelComment(
      {this.id, this.customer, this.avatar, this.comment, this.created});
  ModelComment.fromJson(Map json) {
    id = json['id'];
    customer = json['customer'];
    avatar = json['avatar'];
    comment = json['comment'];
    created = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['avatar'] = this.avatar;
    data['comment'] = this.comment;
    data['created_at'] = this.created;
    return data;
  }
}
