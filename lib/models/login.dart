class LoginModel {
  bool status;
  String message;

  LoginModel({this.status, this.message});
  LoginModel.fromJson(Map<dynamic, dynamic> json) {
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
