import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_project/models/profile_model.dart';
import 'package:api_project/models/sign_up_model.dart';
import 'package:api_project/models/login_model.dart';
import 'package:api_project/models/status_model.dart';

import 'package:http/http.dart' as http;

class AppService {
  static String domain = 'http://10.0.2.2:8000/api/';
  static String? token;
  static Data? user;

  Future<StatusModel> register(SignUp signUp) async {
    //register methodu future döndürür çünkü asenkron bir işlemdir.bu işlem sonucunda StatusModel nesnesi döndürülür
    var client = http
        .Client(); //http sınıfından bir istemci(client) oluşturulur. bu client sunucuyla http isteklerini yapmamızı sağlar

    try {
      var response = //client.post gönderiyoruz çünkü register işlemi. ardından Uri.parse yöntemi ile belirtilen url ye istek gönderilir
          await client.post(Uri.parse('${domain}auth/register'), body: {
        "name": signUp
            .name, //body paramatresi isteğin gövdesine gönderilecek dataları içerir. bunları signUp nesnesinden alınır
        "email": signUp
            .email, //signUp nesnesinde hangi datalar var ise onlar alınır. burada name, surname, email, password ve user_type vaar.
        "surname": signUp.surname,
        "user_type": signUp.user_type,
        "password": signUp.password,
      }, headers: {
        //isteğin başlıkarını içerir
        'Accept':
            'application/json', //sunucuya JSON formatında veri gönderdiğimizi belirtir
      }).timeout(const Duration(
              seconds:
                  10)); // istegin zaman aşım süresi belirlenir 10 sn geçerse istek zaman aşımına uğrar

      if (response.statusCode == 200) {
        //statusCode istekten sonra dönen yanıtı kontrol eder.
        var responseData = json.decode(response
            .body); //yanıt başarılı oldugunda, response.body gövdesi json.decode kullanarak resposeData ya dönüştürülür.

        return StatusModel.fromJson(
            responseData); //dönen JSON datasıStatusModel.fromJson yöntemiyle 'StatuaModel' nesnesine döndürülür ve bu return edilir
      } else {
        throw Exception(
            //eger durum kodu 200 depilse istisna (exception) fırlatır ve hata mesajıyla irlikte istisna olusur
            'Kayıt isteği başarısız. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      //hata durumunda bu blok çalısır. hata mesajı ('e') konsola yazılır ve hata durumunu temsil eden bir StatusModel dönderilir
      print('Hata: $e');
      return StatusModel(message: 'Beklenmedik bir durum', status: false);
    }
  }

  Future<StatusModel> login(Login login) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse('${domain}auth/login'), body: {
        "email": login.email,
        "password": login.password,
      }, headers: {
        "Accept": "application/json"
      }).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return StatusModel.fromJson(responseData);
      } else {
        throw Exception(
            'Kayıt işlemi başarısız oldu. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
      return StatusModel(
          message: 'Beklenmedik bir durum oluştu', status: false);
    }
  }

  Future<ProfileModel?> profile() async {
    var client = http.Client();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      var response =
          await client.get(Uri.parse('${domain}auth/profile'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      }).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var jResponse = json.decode(response.body);
        user = Data.fromJson(jResponse);
        return ProfileModel.fromJson(jResponse);
      } else {
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      StatusModel(message: "Beklenmedik bir durum", status: false);
      return null;
    }
  }
}
