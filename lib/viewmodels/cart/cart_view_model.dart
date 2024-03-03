import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/database/database.dart';
import 'package:jagomart/database/itemsmodel.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/lokasistore.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/cart/cart_model.dart';
import 'package:jagomart/viewmodels/ongkir/ongkir_model.dart';
import 'package:jagomart/viewmodels/saldo/saldo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jagomart/helpers/randomtrans.dart';

enum LoadingStatusCart {
  completed,
  searching,
  empty,
}

class CartListViewModel extends ChangeNotifier {
  LoadingStatusCart loadingStatus = LoadingStatusCart.searching;
  List<CartViewModel> cart = [];

  //Lokasi Store
  List<LokasiStore> store = [];
  List<LokasiStoreTerjauh> lokasistore = [];

  int _totalItems = 0;
  int get totalItems => _totalItems;
  int _totalqty = 0;
  int get totalqty => _totalqty;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;

  int _total = 0;
  int get total => _total;

  Future<void> getcart() async {
    this.loadingStatus = LoadingStatusCart.searching;
    List<CartItem> newcart = await DBProvider.db.getAllCart();
    this.cart = newcart.map((e) => CartViewModel(cart: e)).toList();
    this.store = newcart
        .map((e) => LokasiStore(
            lokasi: LatLng(double.parse(e.lokasi.split(',')[0]),
                double.parse(e.lokasi.split(',')[1])),
            itemid: e.id))
        .toList();
    if (this.cart.isEmpty) {
      this.loadingStatus = LoadingStatusCart.empty;
    } else {
      this.loadingStatus = LoadingStatusCart.completed;
      await getTotalItem();
      await getTotalPrice();
    }

    notifyListeners();
  }

  Future<void> addCart(int itemid, String item, String unit, int disc,
      int price, int pricedisc, String image, String lokasi) async {
    if (this.cart == null || this.cart.isEmpty) {
      await DBProvider.db.newCart(CartItem(
          id: itemid,
          item: item,
          disc: disc,
          unit: unit,
          qty: 1,
          price: price,
          pricedisc: pricedisc,
          image: image,
          lokasi: lokasi));
      // store.add(LokasiStore(lokasi: lokasi, itemid: itemid));
    } else {
      await DBProvider.db.getCart(itemid).then((e) {
        if (e.length > 0) {
          DBProvider.db.updateCart(itemid, e[0].qty + 1);
        } else {
          DBProvider.db.newCart(CartItem(
              id: itemid,
              item: item,
              disc: disc,
              unit: unit,
              qty: 1,
              price: price,
              pricedisc: pricedisc,
              image: image,
              lokasi: lokasi));
          // store.add(LokasiStore(lokasi: lokasi, itemid: itemid));
        }
      });
    }
    await getcart();

    notifyListeners();
  }

  void updateKeranjang(itemid, int qty) async {
    await DBProvider.db.updateCart(itemid, qty);

    await getcart();

    notifyListeners();
  }

  void deletedKeranjang(int index, int itemid) async {
    await DBProvider.db.deleteCart(itemid);
    await getcart();

    notifyListeners();
  }

  void deletedall() async {
    DBProvider.db.deleteAll();
    store.clear();
    await getcart();
  }

  Future<void> getTotalItem() async {
    _totalItems = this.cart.length;
  }

  Future<void> getTotalPrice() async {
    _totalPrice = 0;
    _totalqty = 0;
    for (int i = 0; i < this.cart.length; i++) {
      _totalPrice = _totalPrice + (this.cart[i].pricedisc * this.cart[i].qty);
      _totalqty = _totalqty + this.cart[i].qty;
    }
  }

  //Alamat Pengiriman
  String _alamatSelected;
  String get alamatSelected => _alamatSelected;
  String _mapSelected;
  String get mapSelected => _mapSelected;

  Future<void> getalamat() async {
    this.loadingStatus = LoadingStatusCart.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('alamat') == null || prefs.getString('alamat') == '') {
      _alamatSelected = 'Silahkan Tentukan alamat anda disini.';
      _mapSelected = null;
      await getWaktu();
      this.loadingStatus = LoadingStatusCart.empty;
    } else {
      _alamatSelected = prefs.getString('alamat');
      _mapSelected = prefs.getString('imgmap');
      // await getDistanceRate();
      await getDistance();
      await checkOngkir();
      await getWaktu();
      this.loadingStatus = LoadingStatusCart.completed;
    }

    notifyListeners();
  }

  //Payment
  String _paymentSelected;
  String get paymentSelected => _paymentSelected;
  String _iconpaymentSelected;
  String get iconpaymentSelected => _iconpaymentSelected;
  String _rekeningSelected;
  String get rekeningSelected => _rekeningSelected;

  Future<void> getPayment() async {
    this.loadingStatus = LoadingStatusCart.searching;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('payment') == null) {
      _iconpaymentSelected = null;
      _rekeningSelected = null;
      _paymentSelected = 'Silahkan Pilih Metode Pembayaran';
      this.loadingStatus = LoadingStatusCart.empty;
    } else {
      _paymentSelected = prefs.getString('payment');
      _iconpaymentSelected = prefs.getString('iconpayment');
      _rekeningSelected = prefs.getString('rekening');
    }
    this.loadingStatus = LoadingStatusCart.completed;
    notifyListeners();
  }

  double _waktu = 0;
  double get waktu => _waktu;

  String _distance = "0";
  String get distance => _distance;

  String _dis = "0";
  String get dis => _dis;

  Future<void> getWaktu() async {
    final s = 80;
    final double jarak = double.parse(distance) * 1000;
    _waktu = (jarak / s);
    notifyListeners();
  }

  //Ongkir
  List<OngkirViewModel> ongkir = [];

  double _ongkir = 0;
  double get ongkos => _ongkir;

  Future<void> getongkir() async {
    this.loadingStatus = LoadingStatusCart.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<OngkirModel> newongkir = await Webservice().getongkir(token);

    this.ongkir = newongkir.map((e) => OngkirViewModel(ongkir: e)).toList();

    if (this.ongkir.isEmpty) {
      this.loadingStatus = LoadingStatusCart.empty;
    } else {
      // await getDistanceRate();
      await getDistance();
      await checkOngkir();
      this.loadingStatus = LoadingStatusCart.completed;
    }
    notifyListeners();
  }

  Future<void> getDistance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double palingjauh = 0;
    // ignore: unused_local_variable
    double palingdekat = 0;
    lokasistore.clear();
    for (int i = 0; i < this.cart.length; i++) {
      String str = this.cart[i].lokasi;
      var arrlocation = str.split(',');
      print(double.parse(arrlocation[0]));
      print(double.parse(arrlocation[1]));
      _dis = await CalculateDistance().calculateDistanceCabang(
          LatLng(prefs.getDouble('latitude'), prefs.getDouble('longitude')),
          LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1])));
      lokasistore.add(LokasiStoreTerjauh(
          lokasi: LatLng(
              double.parse(arrlocation[0]), double.parse(arrlocation[1])),
          distance: double.parse(dis)));
    }
    palingjauh = lokasistore.map<double>((e) => e.distance).reduce(max);
    palingdekat = lokasistore.map<double>((e) => e.distance).reduce(min);
    final suggestjauh = lokasistore
        .where((e) => e.distance
            .toString()
            .toLowerCase()
            .contains(palingjauh.toString().toLowerCase()))
        .toList();
    final suggestdekat = lokasistore
        .where((e) => e.distance
            .toString()
            .toLowerCase()
            .contains(palingdekat.toString().toLowerCase()))
        .toList();

    var _jarak;
    if (suggestjauh[0].distance != suggestdekat[0].distance) {
      _jarak = (suggestjauh[0].distance - suggestdekat[0].distance) +
          suggestjauh[0].distance;
    } else {
      _jarak = suggestjauh[0].distance;
    }
    _distance = (_jarak / 1000).toString();
    notifyListeners();
  }

  // Future<void> getDistanceRate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   double palingjauh = 0;
  //   // ignore: unused_local_variable
  //   double palingdekat = 0;
  //   lokasistore.clear();
  //   for (int i = 0; i < store.length; i++) {
  //     _dis = await CalculateDistance().calculateDistanceCabang(
  //         LatLng(prefs.getDouble('latitude'), prefs.getDouble('longitude')),
  //         store[i].lokasi);
  //     lokasistore.add(LokasiStoreTerjauh(
  //         lokasi: store[i].lokasi, distance: double.parse(dis)));
  //   }
  //   palingjauh = lokasistore.map<double>((e) => e.distance).reduce(max);
  //   palingdekat = lokasistore.map<double>((e) => e.distance).reduce(min);
  //   final suggest = lokasistore
  //       .where((e) => e.distance
  //           .toString()
  //           .toLowerCase()
  //           .contains(palingjauh.toString().toLowerCase()))
  //       .toList();

  //   _distance = await CalculateDistance().calculateDistance(
  //       LatLng(prefs.getDouble('latitude'), prefs.getDouble('longitude')),
  //       suggest[0].lokasi);
  //   notifyListeners();
  // }

  Future<void> checkOngkir() async {
    if (double.parse(distance) < this.ongkir[0].min) {
      _ongkir = double.parse(this.ongkir[0].ratesmin.toString());
    } else if (double.parse(distance) <=
        double.parse(this.ongkir[0].max.toString())) {
      var jarak = double.parse(distance) - this.ongkir[0].min;
      _ongkir = (double.parse(this.ongkir[0].ratesmin.toString()) +
          (jarak * double.parse(this.ongkir[0].rates.toString())));
    } else {
      _ongkir = (double.parse(this.ongkir[0].ratesmin.toString()) +
          (double.parse(this.ongkir[0].rates.toString()) *
              double.parse(this.ongkir[0].max.toString())));
    }
    notifyListeners();
  }

  //Saldo
  List<SaldoViewModel> saldo = [];

  Future<void> getsaldo() async {
    saldo.clear();
    this.loadingStatus = LoadingStatusCart.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<SaldoModel> newsaldo = await Webservice().getSaldo(token);

    this.saldo = newsaldo.map((e) => SaldoViewModel(saldo: e)).toList();

    if (this.saldo.isEmpty) {
      this.loadingStatus = LoadingStatusCart.empty;
    } else {
      this.loadingStatus = LoadingStatusCart.completed;
    }
    notifyListeners();
  }

  int _saldo = 0;
  int get saldocust => _saldo;

  int _grandtotal = 0;
  int get grandtotal => _grandtotal;

  bool _cheksaldo = false;
  bool get checksaldo => _cheksaldo;

  Future<void> getchecklist(bool isCheck) async {
    _cheksaldo = isCheck;
    _grandtotal = totalPrice + int.parse(ongkos.toStringAsFixed(0));
    if (isCheck) {
      if (this.saldo[0].saldo < 1000) {
        _saldo = 0;
      } else {
        _cheksaldo = isCheck;
        if (grandtotal > this.saldo[0].saldo) {
          _saldo = this.saldo[0].saldo;
        } else {
          _saldo = grandtotal;
        }
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('statusPayment') == 1) {
        _cheksaldo = true;
        if (grandtotal > this.saldo[0].saldo) {
          _saldo = this.saldo[0].saldo;
        } else {
          _saldo = grandtotal;
        }
      } else {
        _saldo = 0;
      }
    }
    notifyListeners();
  }

  //Insert Transaksi
  Future insertTransaksi(remarks, ongkir, saldo, paysaldo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final deliverid = prefs.getString('deliverid');
    final payid = prefs.getString('payid');
    final paystatus = prefs.getInt('statusPayment');
    List<CartItem> newcart = await DBProvider.db.getAllCart();
    TransaksiModel result = await Webservice().inserttrans(
        token,
        randomTransId(4),
        deliverid,
        totalqty,
        totalPrice,
        ongkir,
        remarks,
        0,
        payid,
        (paystatus == 1) ? 0 : 1,
        saldocust,
        saldo,
        paysaldo,
        Config.nearby,
        json.encode(newcart.map((e) => e.toMap()).toList()));
    DBProvider.db.deleteAll();

    return result;
  }
}
