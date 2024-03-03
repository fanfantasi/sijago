class KategoriModel {
  int id;
  String kategori;
  int dashboard;
  String icon;
  int layout;

  KategoriModel(
      {this.id, this.kategori, this.dashboard, this.icon, this.layout});
  KategoriModel.fromJson(Map json) {
    id = json['id'];
    kategori = json['kategori'];
    dashboard = json['dashboard'];
    icon = json['icon'];
    layout = json['layout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['kategori'] = this.kategori;
    data['dashboard'] = this.dashboard;
    data['icon'] = this.icon;
    data['layout'] = this.layout;
    return data;
  }
}
