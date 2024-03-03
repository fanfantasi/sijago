class CartItem {
  int id;
  String item;
  String unit;
  int price;
  int disc;
  int qty;
  int pricedisc;
  String image;
  String lokasi;

  CartItem({
    this.id,
    this.item,
    this.unit,
    this.price,
    this.disc,
    this.qty,
    this.pricedisc,
    this.image,
    this.lokasi,
  });

  factory CartItem.fromMap(Map<String, dynamic> json) => new CartItem(
      id: json["item_id"],
      item: json["item"],
      unit: json["unit"],
      price: json["price"],
      disc: json["disc"],
      qty: json["qty"],
      pricedisc: json["pricedisc"],
      image: json["image"],
      lokasi: json["lokasi"]);

  Map<String, dynamic> toMap() => {
        "item_id": id,
        "item": item,
        "unit": unit,
        "price": price,
        "disc": disc,
        "qty": qty,
        "pricedisc": pricedisc,
        "image": image,
        "lokasi": lokasi
      };
}
