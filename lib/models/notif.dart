class NotifModel {
  String id;
  String notifid;
  String title;
  String message;
  String image;
  int read;
  int status;
  String created;

  NotifModel(
      {this.id,
      this.notifid,
      this.title,
      this.message,
      this.image,
      this.read,
      this.status,
      this.created});
  NotifModel.fromJson(Map json) {
    id = json['id'];
    notifid = json['notifid'];
    title = json['title'];
    message = json['message'];
    image = json['image'];
    read = json['read'];
    status = json['status'];
    created = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['notifid'] = this.notifid;
    data['title'] = this.title;
    data['message'] = this.message;
    data['image'] = this.image;
    data['read'] = this.read;
    data['status'] = this.status;
    data['created_at'] = this.created;
    return data;
  }
}
