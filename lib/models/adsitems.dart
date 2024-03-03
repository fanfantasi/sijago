class AdsItemsModel {
  String id;
  String title;
  String jenis;
  String stock;
  int price;
  String fasilitas;
  String image;
  String desc;

  AdsItemsModel(
      {this.id,
      this.title,
      this.jenis,
      this.stock,
      this.price,
      this.fasilitas,
      this.image,
      this.desc});
  AdsItemsModel.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    jenis = json['jenis'];
    stock = json['stock'];
    price = json['price'];
    image = json['image'];
    fasilitas = json['fasilitas'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['title'] = this.title;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['jenis'] = this.jenis;
    data['fasilitas'] = this.fasilitas;
    data['image'] = this.image;
    data['desc'] = this.desc;
    return data;
  }
}
