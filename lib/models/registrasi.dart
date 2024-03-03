class RegistrasiModel {
  bool status;
  String message;

  RegistrasiModel({this.status,this.message});
  RegistrasiModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}