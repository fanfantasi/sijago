import 'package:flutter/widgets.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/terms/terms_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatusTerms {
  completed,
  searching,
  empty,
}

class TermsListViewModel extends ChangeNotifier {
  LoadingStatusTerms loadingStatus = LoadingStatusTerms.searching;

  List<TermsViewModel> terms = [];

  void getterms(field) async {
    this.loadingStatus = LoadingStatusTerms.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<TermsModel> newterms = await Webservice().getTerms(token, field);

    this.terms = newterms.map((e) => TermsViewModel(terms: e)).toList();

    if (this.terms.isEmpty) {
      this.loadingStatus = LoadingStatusTerms.empty;
    } else {
      this.loadingStatus = LoadingStatusTerms.completed;
    }
    notifyListeners();
  }
}
