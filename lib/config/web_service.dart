import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/models/models.dart';

class Webservice {
  var dio = Dio();

  //Get Phone
  Future<List<LoginModel>> getPhone(String phone) async {
    try {
      FormData formData = FormData.fromMap({
        'phone': phone,
      });
      final response = await dio.post(server + 'auth/login', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((phone) => LoginModel.fromJson(phone)).toList();
      } else {
        throw Exception("Failled to get lokasi cabang");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Get Email
  Future<List<EmailModel>> getEmail(String email) async {
    try {
      FormData formData = FormData.fromMap({
        'email': email,
      });
      final response = await dio.post(server + 'auth/email', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((email) => EmailModel.fromJson(email)).toList();
      } else {
        throw Exception("Failled to get lokasi cabang");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Registrasi
  Future<List<RegistrasiModel>> sendRegistrasi(name, phone, email) async {
    try {
      FormData formData =
          FormData.fromMap({'fullname': name, 'phone': phone, 'email': email});
      final response = await dio.post(server + 'auth/register', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => RegistrasiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get lokasi cabang");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Send OTP
  Future<List<LoginModel>> sendOtp(String phone) async {
    try {
      FormData formData = FormData.fromMap({
        'phone': phone,
      });
      final response = await dio.post(server + 'auth/sendotp', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => LoginModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get lokasi cabang");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Get OTP
  Future<List<LoginModel>> getOtp(otp, phone, uuid) async {
    try {
      FormData formData =
          FormData.fromMap({'otp': otp, 'phone': phone, 'uuid': uuid});
      final response = await dio.post(server + 'auth/otp', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => LoginModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get lokasi cabang");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Location
  Future<List<LokasiModel>> getLokasi() async {
    try {
      final response = await dio.get(server + 'location');

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((lokasi) => LokasiModel.fromJson(lokasi)).toList();
      } else {
        throw Exception("Failled to get lokasi cabang");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Mitra
  Future<List<MitraModel>> getMitra(int start, String location) async {
    try {
      FormData formData = FormData.fromMap({'location': location});
      final response =
          await dio.post(server + 'mitra?page=$start', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => MitraModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Mitra");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Saldo
  Future<List<SaldoModel>> getSaldo(token) async {
    try {
      final response = await dio.get(server + 'user/saldo',
          options: new Options(headers: {'auth-token': token}));

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => SaldoModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get saldo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Banner
  Future<List<BannersModel>> getBanner(token) async {
    try {
      final response = await dio.get(server + 'banners',
          options: new Options(headers: {'auth-token': token}));

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => BannersModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get saldo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Banner Kategori
  Future<List<BannerKategoriModel>> getBannerCategory(token, String id) async {
    try {
      FormData formData = FormData.fromMap({'category': id});
      final response = await dio.post(server + 'banners/category',
          data: formData, options: new Options(headers: {'auth-token': token}));

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => BannerKategoriModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Banner");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Kategori
  Future<List<KategoriModel>> getKategori(token) async {
    try {
      final response = await dio.get(server + 'category',
          options: new Options(headers: {'auth-token': token}));

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => KategoriModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Category");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Promo
  Future<List<PromoModel>> getPromo(token, int start, String location) async {
    try {
      FormData formData = FormData.fromMap({'location': location});
      final response = await dio.post(server + 'items/promo?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => PromoModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Items
  Future<List<ItemsModel>> getItems(token, int start, String location) async {
    try {
      FormData formData = FormData.fromMap({'location': location});
      final response = await dio.post(server + 'items/new?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Items Mitra
  Future<List<ItemsModel>> getItemsMitra(int start, String location) async {
    try {
      FormData formData = FormData.fromMap({'location': location});
      final response =
          await dio.post(server + 'items/mitra?page=$start', data: formData);
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Items Best Seller
  Future<List<ItemsModel>> getBestSeller(
      token, int start, String location) async {
    try {
      FormData formData = FormData.fromMap({'location': location});
      final response = await dio.post(server + 'items/bestseller?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Items Kategori
  Future<List<ItemsModel>> getItemsByCategory(
      token, int start, String category, String location) async {
    try {
      FormData formData =
          FormData.fromMap({'location': location, 'category': category});
      final response = await dio.post(server + 'items/category?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Related Items
  Future<List<RelatedModel>> getRelated(
      token, int start, String location, String tags) async {
    try {
      FormData formData =
          FormData.fromMap({'location': location, 'tags': tags});
      final response = await dio.post(server + 'items/related?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => RelatedModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Related Items
  Future<List<UlasanItemModel>> getUlasan(token, String item) async {
    try {
      FormData formData = FormData.fromMap({'item': item});
      final response = await dio.post(server + 'rating',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => UlasanItemModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Ulasan");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Search
  Future<List<ItemsModel>> getSearchItems(
      token, int start, String location, String search) async {
    try {
      FormData formData =
          FormData.fromMap({'location': location, 'search': search});
      final response = await dio.post(server + 'items/search?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Promo");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Favorit
  Future<List<ItemsModel>> getFavorit(token, int start) async {
    try {
      final response = await dio.get(server + 'favorit?page=$start',
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Favorit");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  Future<List<AksiModel>> getFavoritByid(
      token, String itemid, bool status) async {
    try {
      FormData formData = FormData.fromMap({'itemid': itemid});
      var response;
      if (status) {
        response = await dio.put(server + 'favorit/user',
            data: formData,
            options: new Options(headers: {'auth-token': token}));
      } else {
        response = await dio.post(server + 'favorit/user',
            data: formData,
            options: new Options(headers: {'auth-token': token}));
      }

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Favorit");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //unFavorit
  Future<List<AksiModel>> getUnfavoritByid(token, String itemid) async {
    try {
      FormData formData = FormData.fromMap({'itemid': itemid});
      var response = await dio.delete(server + 'favorit/user',
          data: formData, options: new Options(headers: {'auth-token': token}));

      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Favorit");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Alamat Customer
  Future<List<AlamatModel>> getAlamat(token) async {
    try {
      final response = await dio.get(server + 'user/address',
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => AlamatModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  Future<AksiModel> removeAlamat(token, id) async {
    try {
      FormData formData = FormData.fromMap({'id': id});
      final response = await dio.delete(server + 'user/address',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        return AksiModel.fromJson(json.decode(response.toString()));
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Payment
  Future<List<PaymentModel>> getPayment(token) async {
    try {
      final response = await dio.get(server + 'methodepayment',
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => PaymentModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Profil
  Future<List<ProfilModel>> getProfil(token) async {
    try {
      final response = await dio.get(server + 'user',
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ProfilModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Profil
  Future<List<AksiModel>> updateProfil(
      token, fullname, gender, email, address) async {
    try {
      FormData formData = FormData.fromMap({
        'name': fullname,
        'gender': gender,
        'email': email,
        'address': address
      });
      final response = await dio.post(server + 'user/update',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Profil
  Future<List<AksiModel>> updateProfilOnAvatar(
      token, fullname, gender, email, address, avatar) async {
    try {
      String fileName = avatar.split('/').last;
      FormData formData = FormData.fromMap({
        'name': fullname,
        'gender': gender,
        'email': email,
        'address': address,
        'photo': await MultipartFile.fromFile(avatar, filename: fileName),
      });
      final response = await dio.post(server + 'user',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Terms
  Future<List<TermsModel>> getTerms(token, field) async {
    try {
      FormData formData = FormData.fromMap({
        'field': field,
      });
      final response = await dio.post(server + 'terms',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => TermsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Profil
  Future<AksiModel> addAlamat(
      token, fullname, phone, address, location, map) async {
    try {
      String fileName = map.split('/').last;
      FormData formData = FormData.fromMap({
        'name': fullname,
        'phone': phone,
        'address': address,
        'location': location,
        'photo': await MultipartFile.fromFile(map, filename: fileName),
      });
      final response = await dio.post(server + 'user/address',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        return AksiModel.fromJson(json.decode(response.toString()));
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Ongkir
  Future<List<OngkirModel>> getongkir(token) async {
    try {
      FormData formData = FormData.fromMap({
        'location': Config.nearby,
      });
      final response = await dio.post(server + 'rates',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => OngkirModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Insert Transaksi
  Future<TransaksiModel> inserttrans(
      token,
      transid,
      deliverid,
      totalqty,
      totalprice,
      ongkir,
      remarks,
      transstatus,
      payid,
      paystatus,
      paysaldo,
      oldsaldo,
      newsaldo,
      cabang,
      detail) async {
    try {
      var link = server + "user/transjago";
      FormData formData = FormData.fromMap({
        'transid': transid,
        'deliverid': deliverid,
        'totalqty': totalqty,
        'totalprice': totalprice,
        'ongkir': ongkir,
        'remarks': remarks,
        'transstatus': transstatus,
        'payid': payid,
        'paystatus': paystatus,
        'paysaldo': paysaldo,
        'oldsaldo': oldsaldo,
        'newsaldo': newsaldo,
        'cabang': cabang,
        'detail': detail
      });
      final response = await dio.post(link,
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        return TransaksiModel.fromJson(json.decode(response.toString()));
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Ongkir
  Future<List<OrdersModel>> getorder(token, id) async {
    try {
      final response = await dio.get(server + 'user/historytransaksi?page=$id',
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => OrdersModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Ongkir By Id
  Future<List<OrdersModel>> getorderbyid(token, id) async {
    try {
      FormData formData = FormData.fromMap({'transid': id});
      final response = await dio.post(server + 'user/historytransaksi',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => OrdersModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Review
  Future<List<AksiModel>> insertReview(token, id, rating, remarks, data) async {
    try {
      FormData formData = FormData.fromMap(
          {'transid': id, 'rating': rating, 'remarks': remarks, 'data': data});
      final response = await dio.post(server + 'user/review',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Confirm
  Future<List<AksiModel>> confirmOrder(token, id, ongkir, driverid) async {
    try {
      FormData formData = FormData.fromMap(
          {'transid': id, 'ongkir': ongkir, 'driverid': driverid});
      final response = await dio.post(server + 'user/confirmorder',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Tracking
  Future<List<TrackingModel>> getTracking(token, id) async {
    try {
      FormData formData = FormData.fromMap({'transid': id});
      final response = await dio.post(server + 'user/tracking',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => TrackingModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Alamat");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Notif
  Future<List<NotifModel>> getNotif(token, int start) async {
    try {
      final response = await dio.get(server + 'notifikasi?page=$start',
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => NotifModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Ads
  Future<List<AdsModel>> getAds(int start, int posisi, String location) async {
    try {
      FormData formData =
          FormData.fromMap({'posisi': posisi, 'location': location});
      final response =
          await dio.post(server + 'ads?page=$start', data: formData);
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => AdsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Ads Detail
  Future<List<AdsItemsModel>> getAdsItems(int start, String adsid) async {
    try {
      FormData formData = FormData.fromMap({
        'adsid': adsid,
      });
      final response =
          await dio.post(server + 'ads/items?page=$start', data: formData);
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => AdsItemsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //News
  Future<List<NewsModel>> getNews(int start) async {
    try {
      final response = await dio.get(server + 'news?page=$start');
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => NewsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Komment
  Future<List<ModelComment>> getcomment(token, int start, newsid) async {
    try {
      FormData formData = FormData.fromMap({
        'newsid': newsid,
      });
      final response = await dio.post(server + 'news/comment?page=$start',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ModelComment.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //Comment Add
  Future<List<ModelComment>> getinitcomment(token, newsid, comment) async {
    try {
      FormData formData =
          FormData.fromMap({'newsid': newsid, 'comment': comment});
      final response = await dio.post(server + 'news/newscomment',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => ModelComment.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //News Liked
  Future<List<LikeModel>> getLike(token, newsid) async {
    try {
      var params = {
        "newsid": newsid,
      };
      final response = await dio.post(server + 'news/customer',
          data: jsonEncode(params),
          options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result['result'];
        return list.map((e) => LikeModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //News Liked
  Future<List<AksiModel>> getinitlike(token, int newsid, int like) async {
    try {
      FormData formData = FormData.fromMap({'newsid': newsid, 'like': like});
      final response = await dio.post(server + 'news/like',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }

  //News Liked Del
  Future<List<AksiModel>> getdeletedlike(token, int newsid, int like) async {
    try {
      FormData formData = FormData.fromMap({'newsid': newsid, 'like': like});
      final response = await dio.delete(server + 'news/like',
          data: formData, options: new Options(headers: {'auth-token': token}));
      if (response.statusCode == 200) {
        final result = response.data;
        Iterable list = result;
        return list.map((e) => AksiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failled to get Notif");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        throw Exception("Server sedang sibuk");
      } else {
        throw Exception("Koneksi internet terputus");
      }
    }
  }
}
