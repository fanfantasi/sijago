class OrdersModel {
  String id;
  String transid;
  int driverid;
  int deliverid;
  String datetrans;
  int qty;
  int totalprice;
  int ongkir;
  String remarks;
  int status;
  int transstatus;
  int statusdone;
  int payid;
  String payment;
  String icon;
  int paystatus;
  int methodstatus;
  String rekening;
  int paysaldo;
  int cabang;
  List<ResultsDetailOrder> items;
  int review;

  OrdersModel(
      {this.id,
      this.transid,
      this.driverid,
      this.deliverid,
      this.datetrans,
      this.qty,
      this.totalprice,
      this.ongkir,
      this.remarks,
      this.status,
      this.transstatus,
      this.statusdone,
      this.payid,
      this.payment,
      this.icon,
      this.paystatus,
      this.methodstatus,
      this.rekening,
      this.cabang,
      this.paysaldo,
      this.items,
      this.review});
  OrdersModel.fromJson(Map json) {
    id = json['_id'];
    transid = json['transid'];
    driverid = json['driverid'];
    deliverid = json['deliverid'];
    datetrans = json['datetrans'];
    qty = json['qty'];
    totalprice = json['totalprice'];
    ongkir = json['ongkir'];
    remarks = json['remarks'];
    status = json['status'];
    transstatus = json['trans_status'];
    statusdone = json['statusdone'];
    payid = json['pay_id'];
    payment = json['payment'];
    icon = json['icon'];
    paystatus = json['pay_status'];
    methodstatus = json['method_status'];
    rekening = json['rekening'];
    cabang = json['cabang'];
    paysaldo = json['pay_saldo'];
    if (json['items'].isNotEmpty) {
      items = [];
      json['items'].forEach((v) {
        items.add(new ResultsDetailOrder.fromJson(v));
      });
    }
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['transid'] = this.transid;
    data['driverid'] = this.driverid;
    data['deliverid'] = this.deliverid;
    data['datetrans'] = this.datetrans;
    data['qty'] = this.qty;
    data['totalprice'] = this.totalprice;
    data['ongkir'] = this.ongkir;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    data['trans_status'] = this.transstatus;
    data['statusdone'] = this.statusdone;
    data['pay_id'] = this.payid;
    data['payment'] = this.payment;
    data['icon'] = this.icon;
    data['pay_status'] = this.paystatus;
    data['method_status'] = this.methodstatus;
    data['rekening'] = this.rekening;
    data['pay_saldo'] = this.paysaldo;
    data['cabang'] = this.cabang;
    if (this.items.isNotEmpty) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['review'] = this.review;
    return data;
  }
}

class ResultsDetailOrder {
  String id;
  String item;
  String unit;
  int price;
  int qty;
  int disc;
  int subtotal;

  ResultsDetailOrder(
      {this.item, this.unit, this.price, this.qty, this.disc, this.subtotal});
  ResultsDetailOrder.fromJson(Map json) {
    id = json['item_id'];
    item = json['item'];
    unit = json['unit'];
    price = json['price'];
    qty = json['qty'];
    disc = json['disc'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['item_id'] = this.id;
    data['item'] = this.item;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['disc'] = this.disc;
    data['subtotal'] = this.subtotal;
    return data;
  }
}
