import 'package:jagomart/models/models.dart';

class KomentarViewModel {
  ModelComment _komentar;
  KomentarViewModel({ModelComment komentar}) : _komentar = komentar;

  String get id {
    return _komentar.id;
  }

  String get customer {
    return _komentar.customer;
  }

  String get avatar {
    return _komentar.avatar;
  }

  String get komentar {
    return _komentar.comment;
  }

  String get created {
    return _komentar.created;
  }
}
