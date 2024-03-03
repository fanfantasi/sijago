class SearchItem {
  int id;
  int category;
  String item;

  SearchItem({this.id, this.category, this.item});

  factory SearchItem.fromMap(Map<String, dynamic> json) => new SearchItem(
      id: json["rowid"], category: json["category"], item: json["item"]);

  Map<String, dynamic> toMap() =>
      {"rowid": id, "category": category, "item": item};
}
