class TermsModel {
  String message;

  TermsModel({this.message});
  TermsModel.fromJson(Map<dynamic, dynamic> json) {
    message = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['terms'] = this.message;
    return data;
  }
}
