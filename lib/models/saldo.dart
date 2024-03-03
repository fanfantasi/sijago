class SaldoModel {
  int saldo;

  SaldoModel({this.saldo});
  SaldoModel.fromJson(Map json) {
    saldo = json['saldo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['saldo'] = this.saldo;
    return data;
  }
}
