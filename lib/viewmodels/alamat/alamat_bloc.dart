import 'dart:convert';

import 'package:form_bloc/form_bloc.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/profil/profil_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressFormBloc extends FormBloc<String, String> {
  List<ProfilViewModel> profil = [];
  static String _min9Char(String phone) {
    if (phone.length < 9) {
      return 'No Ponsel minimal 9 Karakter';
    }
    return null;
  }

  static String _min4Char(String nama) {
    if (nama.length < 3) {
      return 'Nama Minimal 3 Karakter';
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

  final alamat = TextFieldBloc(
    name: 'address',
    validators: [FieldBlocValidators.required],
  );

  final name = TextFieldBloc(
    name: 'nama',
    validators: [FieldBlocValidators.required, _min4Char],
  );

  AddressFormBloc() : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [phone, alamat, name]);
  }

  @override
  void onLoading() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 200));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ProfilModel> newprofil = await Webservice().getProfil(token);
      this.profil = newprofil.map((e) => ProfilViewModel(profil: e)).toList();
      phone.updateInitialValue(this.profil[0].phone);
      name.updateInitialValue(this.profil[0].fullname);
      alamat.updateInitialValue(this.profil[0].address);
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
