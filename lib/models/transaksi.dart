class TransaksiModel {
  bool status;
  String message;
  String transid;

  TransaksiModel({this.status, this.message, this.transid});
  TransaksiModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['result'];
    transid = json['transid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['status'] = this.status;
    data['result'] = this.message;
    data['transid'] = this.transid;
    return data;
  }
}
