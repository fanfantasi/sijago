import 'package:jagomart/models/models.dart';

class RegistrasiViewModel {
  RegistrasiModel _registrasi;
  RegistrasiViewModel({RegistrasiModel registrasi}) : _registrasi = registrasi;

  bool get status {
    return _registrasi.status;
  }

  String get message {
    return _registrasi.message;
  }
}
