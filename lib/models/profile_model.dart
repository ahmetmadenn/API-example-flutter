class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? surname;
  int? userType;
  String? email;
  Null? emailVerifiedAt;
  String? money;
  Null? photo;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.surname,
      this.userType,
      this.email,
      this.emailVerifiedAt,
      this.money,
      this.photo,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    userType = json['user_type'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    money = json['money'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['money'] = this.money;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
