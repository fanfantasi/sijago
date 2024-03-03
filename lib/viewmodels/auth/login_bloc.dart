import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/auth/login_model.dart';

class AsyncPhoneFormBloc extends FormBloc<String, String> {
  List<LoginViewModel> login = [];

  static String _min10Char(String phone) {
    if (phone.length < 9) {
      return 'No Ponsel minimal 9 Karakter';
    }
    return null;
  }

  // ignore: close_sinks
  final phone = TextFieldBloc(
    name: 'phone',
    validators: [
      FieldBlocValidators.required,
      _min10Char,
    ],
    asyncValidatorDebounceTime: Duration(milliseconds: 200),
  );

  AsyncPhoneFormBloc() {
    addFieldBloc(fieldBloc: phone);
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 100), () async {
        try {
          List<LoginModel> _phone = await Webservice().getPhone(phone.value);
          this.login = _phone.map((e) => LoginViewModel(login: e)).toList();
          if (this.login[0].status == true) {
            emitSuccess(canSubmitAgain: true, successResponse: phone.value);
          } else {
            emitFailure(failureResponse: this.login[0].message);
          }
          return null;
        } catch (e) {
          emitFailure(failureResponse: "Nomor ponsel tidak ditemukan");
        }
      });
    } catch (e) {
      emitFailure(failureResponse: 'Internet terputus, silahkan diulangi');
    }
  }
}
