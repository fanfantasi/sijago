class TrackingModel {
  String id;
  String transid;
  String message;
  String desc;
  String date;
  String created;

  TrackingModel(
      {this.id,
      this.transid,
      this.message,
      this.desc,
      this.date,
      this.created});
  TrackingModel.fromJson(Map json) {
    id = json['_id'];
    transid = json['transid'];
    message = json['status'];
    desc = json['desc'];
    date = json['created_at'];
    created = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['transid'] = this.transid;
    data['status'] = this.message;
    data['desc'] = this.desc;
    data['created_at'] = this.date;
    data['created_at'] = this.created;
    return data;
  }
}
