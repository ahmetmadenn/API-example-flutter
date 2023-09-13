import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String password = "";
  String name = "";
  String surname = "";

  @override
  void initState() {
    super.initState();
    loadLoginData();
  }

  Future<void> loadLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? "null";
      password = prefs.getString('password') ?? "null";
      name = prefs.getString('name') ?? "null";
      surname = prefs.getString('surname') ?? "null";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kullanıcı E-Postası: $email", style: TextStyle(fontSize: 15)),
            SizedBox(height: 20),
            Text("Kullanıcı Parolası: $password",
                style: TextStyle(fontSize: 15)),
            SizedBox(height: 20),
            Text("Kullanıcı Adı: $name", style: TextStyle(fontSize: 15)),
            SizedBox(height: 20),
            Text("Kullanıcı Soyadı: $surname", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
