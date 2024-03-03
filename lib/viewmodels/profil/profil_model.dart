import 'package:jagomart/models/models.dart';

class ProfilViewModel {
  ProfilModel _profil;
  ProfilViewModel({ProfilModel profil}) : _profil = profil;

  String get id {
    return _profil.id;
  }

  String get noktp {
    return _profil.noktp;
  }

  String get fullname {
    return _profil.fullname;
  }

  String get gender {
    return _profil.gender;
  }

  String get email {
    return _profil.email;
  }

  String get phone {
    return _profil.phone;
  }

  String get address {
    return _profil.address;
  }

  String get avatar {
    return _profil.avatar;
  }
}
