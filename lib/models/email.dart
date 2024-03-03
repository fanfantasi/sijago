class EmailModel {
  bool status;
  String message;
  String email;

  EmailModel({this.status,this.message, this.email});
  EmailModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['status'] = this.status;
    data['message'] = this.message;
    data['email'] = this.email;
    return data;
  }
}