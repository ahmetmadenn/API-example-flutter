import 'package:api_project/models/sign_up_model.dart';
import 'package:api_project/screens/login_page.dart';
import 'package:api_project/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'LÜTFEN GEÇERLİ BİR AD GİRİNİZ';
                  } else if (value.length < 3) {
                    return 'Ad en az 3 harf içermelidir';
                  }
                  return null;
                },
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'LÜTFEN GEÇERLİ BİR SOY AD GİRİNİZ';
                  } else if (value.length < 3) {
                    return 'Soyad en az 3 harf içermelidir';
                  }
                  return null;
                },
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Soyad',
                ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen bir e-posta adresi girin';
                  } else if (value.length < 3) {
                    return 'E-posta adresi en az 3 harf içermelidir';
                  } else if (!value.contains('@') || !value.contains('.com')) {
                    return 'Lütfen geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'E-posta',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'LÜTFEN GEÇERLİ BİR ŞİFRE GİRİNİZ';
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (_passwordController.text.length < 6) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Hata'),
                              content: const Text(
                                  'Şifre en az 6 karakterli olmalıdır'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Tamam'))
                              ],
                            );
                          });
                    }

                    SignUp signUp = SignUp(
                      name: _nameController.text,
                      email: _emailController.text,
                      surname: _surnameController.text,
                      user_type: '1',
                      password: _passwordController.text,
                    );

                    var result = await AppService().register(signUp);

                    if (result.status!) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString('name', '${_nameController.text}');

                      await prefs.setString(
                          'surname', '${_surnameController.text}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    } else {
                      throw Exception('beklenmedik bir hata oluştu ');
                    }
                  }
                },
                child: const Text('Kayıt ol'),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Zaten bir hesabınız var mı?',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Text(' Giriş yap'))
            ],
          ),
        ),
      ),
    );
  }
}
