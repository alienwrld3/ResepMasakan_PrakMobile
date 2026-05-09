import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'locals/sharedpref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('favorites');

  bool isLogin = await SharedPrefService.checkLogin();

  runApp(
    MyApp(isLogin: isLogin),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogin;

  const MyApp({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin
          ? const HomePage()
          : const LoginPage(),
    );
  }
}