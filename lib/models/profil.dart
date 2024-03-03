class ProfilModel {
  String id;
  String noktp;
  String fullname;
  String gender;
  String email;
  String phone;
  String address;
  String avatar;

  ProfilModel(
      {this.id,
      this.noktp,
      this.fullname,
      this.gender,
      this.email,
      this.phone,
      this.address,
      this.avatar});
  ProfilModel.fromJson(Map json) {
    id = json['_id'];
    noktp = json['noktp'];
    fullname = json['fullname'];
    gender = json['gender'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['noktp'] = this.noktp;
    data['fullname'] = this.fullname;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    return data;
  }
}
