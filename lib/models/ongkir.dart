class OngkirModel {
  int id;
  int rates;
  int max;
  int min;
  int ratesmin;

  OngkirModel({this.id, this.rates, this.max});
  OngkirModel.fromJson(Map json) {
    id = json['id'];
    rates = json['rates'];
    max = json['max'];
    min = json['min'];
    ratesmin = json['rates_min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['rates'] = this.rates;
    data['max'] = this.max;
    data['min'] = this.min;
    data['rates_min'] = this.ratesmin;
    return data;
  }
}
