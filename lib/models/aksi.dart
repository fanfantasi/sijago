class AksiModel {
  bool status;
  String message;

  AksiModel({this.status, this.message});
  AksiModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['status'] = this.status;
    data['result'] = this.message;
    return data;
  }
}
