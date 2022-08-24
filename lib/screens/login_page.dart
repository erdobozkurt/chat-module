import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import '../widgets/input_tile_widget.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = 'loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordContoller = TextEditingController();
  bool passwordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordContoller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  style: Theme.of(context).textTheme.headlineLarge,
                  'Welcome Back!',
                ),
              ),
              const Spacer(),
              InputTileWidget(
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Enter email',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),
              InputTileWidget(
                child: TextFormField(
                  controller: passwordContoller,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Enter password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        passwordVisible = !passwordVisible;
                        setState(() {});
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {}, child: const Text('Forgot password?')),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await AuthMethods().signIn(
                        email: emailController.text,
                        password: passwordContoller.text,
                        context: context);
                  },
                  child: Text('Login',
                      style: Theme.of(context).textTheme.headline6),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('Don\'t have an account?')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpPage.routeName);
                },
                child: const Text(
                  'Sign Up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
