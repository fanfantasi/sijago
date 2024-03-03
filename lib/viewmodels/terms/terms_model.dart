import 'package:jagomart/models/models.dart';

class TermsViewModel {
  TermsModel _terms;
  TermsViewModel({TermsModel terms}) : _terms = terms;

  String get message {
    return _terms.message;
  }
}
