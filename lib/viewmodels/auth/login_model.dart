import 'package:jagomart/models/models.dart';

class LoginViewModel {
  LoginModel _login;
  LoginViewModel({LoginModel login}) : _login = login;

  bool get status {
    return _login.status;
  }

  String get message {
    return _login.message;
  }
}
