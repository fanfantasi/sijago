import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/profil.dart';
import 'package:jagomart/viewmodels/profil/profil_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilFormBloc extends FormBloc<String, String> {
  List<ProfilViewModel> profil = [];
  static String _min9Char(String phone) {
    if (phone.length < 9) {
      return 'No Ponsel minimal 9 Karakter';
    }
    return null;
  }

  static String _min2Char(String nama) {
    if (nama.length < 2) {
      return 'Nama Minimal 2 Karakter';
    }
    return null;
  }

  final phone = TextFieldBloc(
    name: 'phone',
    validators: [
      FieldBlocValidators.required,
      _min9Char,
    ],
    asyncValidatorDebounceTime: Duration(milliseconds: 1000),
  );

  final gender = SelectFieldBloc(
      name: 'gender',
      validators: [FieldBlocValidators.required],
      items: ['Laki-laki', 'Perempuan']);

  final address = TextFieldBloc(
    name: 'address',
    validators: [FieldBlocValidators.required],
  );

  final email = TextFieldBloc(
    name: 'email',
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final name = TextFieldBloc(
    name: 'fullname',
    validators: [FieldBlocValidators.required, _min2Char],
  );

  EditProfilFormBloc() : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [phone, email, name, gender, address]);
  }

  @override
  void onLoading() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      await Future<void>.delayed(Duration(milliseconds: 200));
      List<ProfilModel> newprofil = await Webservice().getProfil(token);
      this.profil = newprofil.map((e) => ProfilViewModel(profil: e)).toList();
      phone.updateInitialValue(this.profil[0].phone);
      name.updateInitialValue(this.profil[0].fullname);
      email.updateInitialValue(this.profil[0].email);
      address.updateInitialValue(this.profil[0].address);
      if (this.profil[0].gender == null) {
        gender
          ..updateItems(['Laki-laki', 'Perempuan'])
          ..updateInitialValue('Laki-laki');
      } else {
        gender
          ..updateItems(['Laki-laki', 'Perempuan'])
          ..updateInitialValue(this.profil[0].gender);
      }

      emitLoaded();
    } catch (e) {
      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 500));
      emitSuccess(
          canSubmitAgain: true,
          successResponse: JsonEncoder.withIndent(' ').convert(state.toJson()));
    } catch (e) {
      emitFailure();
    }
  }
}
