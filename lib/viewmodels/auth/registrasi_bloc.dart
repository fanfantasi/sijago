import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/auth/email_model.dart';
import 'package:jagomart/viewmodels/auth/login_model.dart';

class AsyncRegistrasiFormBloc extends FormBloc<String, String> {
  List<LoginViewModel> register = [];
  List<EmailViewModel> chekemail = [];
  static String _min10Char(String phone) {
    if (phone.length < 9) {
      return 'No Ponsel minimal 9 Karakter';
    }
    return null;
  }

  static String _min4Char(String nama) {
    if (nama.length < 4) {
      return 'Nama Minimal 4 Karakter';
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
    asyncValidatorDebounceTime: Duration(milliseconds: 1000),
  );

  // ignore: close_sinks
  final name = TextFieldBloc(
    name: 'nama',
    validators: [FieldBlocValidators.required, _min4Char],
  );

  // ignore: close_sinks
  final email = TextFieldBloc(
    name: 'email',
    validators: [FieldBlocValidators.required, FieldBlocValidators.email],
    asyncValidatorDebounceTime: Duration(milliseconds: 1000),
  );

  AsyncRegistrasiFormBloc() {
    addFieldBlocs(fieldBlocs: [phone, name, email]);
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 100), () async {
        try {
          List<LoginModel> _phone = await Webservice().getPhone(phone.value);
          this.register = _phone.map((e) => LoginViewModel(login: e)).toList();
          List<EmailModel> _email = await Webservice().getEmail(email.value);
          this.chekemail = _email.map((e) => EmailViewModel(email: e)).toList();
          if (this.register[0].status == true) {
            emitFailure(failureResponse: 'Nomor Ponsel sudah digunakan');
          } else if (this.chekemail[0].status == true) {
            emitFailure(failureResponse: 'Email sudah digunakan');
          } else {
            emitSuccess(
                canSubmitAgain: true,
                successResponse:
                    JsonEncoder.withIndent(' ').convert(state.toJson()));
          }
          return null;
        } catch (e) {
          emitFailure(failureResponse: 'Internet terputus, silahkan diulangi');
        }
      });
    } catch (e) {
      emitFailure(failureResponse: 'Internet terputus, silahkan diulangi');
    }
  }
}
