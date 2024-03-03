class PaymentModel {
  int id;
  String payment;
  String rekening;
  int status;
  String icon;

  PaymentModel({this.id, this.payment, this.rekening, this.status, this.icon});
  PaymentModel.fromJson(Map json) {
    id = json['id'];
    payment = json['payment'];
    rekening = json['no_rek'];
    status = json['status'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['payment'] = this.payment;
    data['no_rek'] = this.rekening;
    data['status'] = this.status;
    data['icon'] = this.icon;
    return data;
  }
}
