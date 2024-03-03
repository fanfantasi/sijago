import 'package:jagomart/models/models.dart';

class AksiViewModel {
  AksiModel _aksi;
  AksiViewModel({AksiModel aksi}) : _aksi = aksi;

  bool get status {
    return _aksi.status;
  }

  String get message {
    return _aksi.message;
  }
}
