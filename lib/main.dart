import 'package:chat_module/screens/chat_page.dart';
import 'package:chat_module/screens/home_page.dart';
import 'package:chat_module/screens/login_page.dart';
import 'package:chat_module/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Module',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginPage.routeName
          : ChatPage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ChatPage.routeName: (context) => const ChatPage(),
        LoginPage.routeName:(context) => const LoginPage(),
        SignUpPage.routeName:(context) => const SignUpPage()
      },
    );
  }
}

//TODO: kullanıcı adını mesaj tileda display etme
//TODO: avatarı display etme
//TODO: user mentionlama
