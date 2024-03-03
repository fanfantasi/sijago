import 'package:jagomart/models/models.dart';

class KategoriViewModel {
  KategoriModel _kategori;
  KategoriViewModel({KategoriModel kategori}) : _kategori = kategori;

  int get id {
    return _kategori.id;
  }

  String get kategori {
    return _kategori.kategori;
  }

  int get dashboard {
    return _kategori.dashboard;
  }

  String get icon {
    return _kategori.icon;
  }

  int get layout {
    return _kategori.layout;
  }
}
