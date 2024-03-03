import 'package:jagomart/models/models.dart';

class EmailViewModel {
  EmailModel _email;
  EmailViewModel({EmailModel email}) : _email = email;

  bool get status {
    return _email.status;
  }

  String get message {
    return _email.message;
  }

  String get email {
    return _email.email;
  }
}
