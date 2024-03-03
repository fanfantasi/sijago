import 'package:jagomart/models/models.dart';

class BannerViewModel {
  BannersModel _banner;
  BannerViewModel({BannersModel banner}) : _banner = banner;

  int get id {
    return _banner.id;
  }

  String get banner {
    return _banner.banner;
  }

  String get photo {
    return _banner.photo;
  }
}
