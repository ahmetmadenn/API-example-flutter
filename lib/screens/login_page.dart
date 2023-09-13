import 'package:api_project/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_project/models/login_model.dart';
import 'package:api_project/screens/profile_page.dart';
import 'package:api_project/service/app_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen bir e-posta adresi girin';
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
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'LÜTFEN GEÇERLİ BİR ŞİFRE GİRİN';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('email', _emailController.text);
                    await prefs.setString('password', _passwordController.text);
                    Login login = Login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    var result = await AppService().login(login);

                    if (result.status!) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString(
                        'email',
                        _emailController.text,
                      );
                      await prefs.setString(
                        'password',
                        _passwordController.text,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Hata'),
                              content: const Text(
                                  'E-posta veya Şifre, eksik ya da hatalı.Lütfen tekrar deneyiniz.'),
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
                  }
                },
                child: const Text('Giriş Yap'),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Bir hesabınız yok mu?',
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
                            builder: (context) => const RegisterPage()));
                  },
                  child: Text('Kayıt ol'))
            ],
          ),
        ),
      ),
    );
  }
}
