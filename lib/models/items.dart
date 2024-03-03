import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemsModel {
  String id;
  String item;
  String kategori;
  String group;
  int stock;
  String unit;
  int price;
  int disc;
  int pricedisc;
  List<ListImagesItems> images;
  List<RatingItems> rating;
  String tags;
  String desc;
  String mitraid;
  String mitra;
  String mitraimage;
  LatLng location;
  String jamoperasional;
  String operasional;
  bool operasionalstatus;
  int statusitem;
  String distance;

  ItemsModel(
      {this.id,
      this.item,
      this.group,
      this.stock,
      this.unit,
      this.price,
      this.disc,
      this.pricedisc,
      this.rating,
      this.images,
      this.tags,
      this.desc,
      this.mitraid,
      this.mitra,
      this.mitraimage,
      this.kategori,
      this.location,
      this.jamoperasional,
      this.operasional,
      this.operasionalstatus,
      this.statusitem,
      this.distance});
  ItemsModel.fromJson(Map json) {
    String str = json['location'];
    var arrlocation = str.split(',');
    id = json['_id'];
    item = json['item'];
    stock = json['stock'];
    kategori = json['category'];
    group = json['group'];
    unit = json['unit'];
    price = json['price'];
    disc = json['disc'];
    pricedisc = json['pricedisc'];
    if (json['image'].isNotEmpty) {
      images = [];
      json['image'].forEach((v) {
        images.add(new ListImagesItems.fromJson(v));
      });
    }
    if (json['rating'].isNotEmpty) {
      rating = [];
      json['rating'].forEach((v) {
        rating.add(new RatingItems.fromJson(v));
      });
    }
    tags = json['tags'];
    desc = json['desc'];
    mitraid = json['location_id'];
    mitra = json['location_title'];
    mitraimage = json['location_image'];
    location =
        LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1]));
    jamoperasional = json['jam_operasional'];
    operasional = json['operasional'];
    operasionalstatus = json['status_operasional'];
    statusitem = json['status_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['item'] = this.item;
    data['group'] = this.group;
    data['stock'] = this.stock;
    data['category'] = this.kategori;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['disc'] = this.disc;
    data['pricedisc'] = this.pricedisc;
    data['rating'] = this.rating;
    if (this.images.isNotEmpty) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.rating.isNotEmpty) {
      data['rating'] = this.rating.map((v) => v.toJson()).toList();
    }
    data['tags'] = this.tags;
    data['desc'] = this.desc;
    data['location_id'] = this.mitraid;
    data['location_title'] = this.mitra;
    data['location_image'] = this.mitraimage;
    data['location'] = this.location;
    data['jam_operasional'] = this.jamoperasional;
    data['operasional'] = this.operasional;
    data['status_operasional'] = this.operasionalstatus;
    data['status_item'] = this.statusitem;
    return data;
  }
}

class ListImagesItems {
  String id;
  String image;

  ListImagesItems({this.image});
  ListImagesItems.fromJson(Map json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class RatingItems {
  double rating;
  String sumrating;

  RatingItems({this.rating, this.sumrating});
  RatingItems.fromJson(Map json) {
    rating = json['avg'] == null ? 0.0 : json['avg'].toDouble();
    sumrating = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['avg'] = this.rating;
    data['count'] = this.sumrating;
    return data;
  }
}
