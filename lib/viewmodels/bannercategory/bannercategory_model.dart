import 'package:jagomart/models/models.dart';

class BannerCategoryViewModel {
  BannerKategoriModel _banner;
  BannerCategoryViewModel({BannerKategoriModel banner}) : _banner = banner;

  String get id {
    return _banner.id;
  }

  String get banner {
    return _banner.banner;
  }

  String get photo {
    return _banner.photo;
  }
}
