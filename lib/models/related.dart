import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelatedModel {
  String id;
  String item;
  String kategori;
  String group;
  int stock;
  String unit;
  int price;
  int disc;
  int pricedisc;
  List<ListImagesRelated> images;
  List<RatingRelated> rating;
  String tags;
  String desc;
  String mitraid;
  String mitra;
  String mitraimage;
  LatLng location;
  String jamoperasional;
  String operasional;
  bool operasionalstatus;
  int sould;
  String distance;

  RelatedModel(
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
      this.sould,
      this.mitraid,
      this.mitra,
      this.mitraimage,
      this.kategori,
      this.location,
      this.jamoperasional,
      this.operasional,
      this.operasionalstatus,
      this.distance});
  RelatedModel.fromJson(Map json) {
    String str = json['location'];
    var arrlocation = str.split(',');
    id = json['_id'];
    item = json['item'];
    group = json['group'];
    stock = json['stock'];
    kategori = json['category'];
    unit = json['unit'];
    price = json['price'];
    disc = json['disc'];
    pricedisc = json['pricedisc'];
    if (json['image'].isNotEmpty) {
      images = [];
      json['image'].forEach((v) {
        images.add(new ListImagesRelated.fromJson(v));
      });
    }
    if (json['rating'].isNotEmpty) {
      rating = [];
      json['rating'].forEach((v) {
        rating.add(new RatingRelated.fromJson(v));
      });
    }
    tags = json['tags'];
    desc = json['desc'];
    sould = json['sould'];
    mitraid = json['location_id'];
    mitra = json['location_title'];
    mitraimage = json['location_image'];
    location =
        LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1]));
    jamoperasional = json['jam_operasional'];
    operasional = json['operasional'];
    operasionalstatus = json['status_operasional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['item'] = this.item;
    data['group'] = this.group;
    data['category'] = this.kategori;
    data['stock'] = this.stock;
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
    data['sould'] = this.sould;
    data['location_id'] = this.mitraid;
    data['location_title'] = this.mitra;
    data['location_image'] = this.mitraimage;
    data['location'] = this.location;
    data['jam_operasional'] = this.jamoperasional;
    data['operasional'] = this.operasional;
    data['status_operasional'] = this.operasionalstatus;
    return data;
  }
}

class ListImagesRelated {
  String id;
  String image;

  ListImagesRelated({this.image});
  ListImagesRelated.fromJson(Map json) {
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

class RatingRelated {
  int rating;
  String sumrating;

  RatingRelated({this.rating, this.sumrating});
  RatingRelated.fromJson(Map json) {
    rating = json['avg'];
    sumrating = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['avg'] = this.rating;
    data['count'] = this.sumrating;
    return data;
  }
}
