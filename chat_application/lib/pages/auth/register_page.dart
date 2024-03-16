import 'package:chat_application/helper/helper_function.dart';
import 'package:chat_application/pages/home_page.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Fluent Flow", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                const Text("Create your account to chat and explore!", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                Image.asset("assets/register.png"),
                const SizedBox(height: 15,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                      print(fullName);
                    });
                  },
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  },
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                      print(email);
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Register", style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {
                      register();
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: " Register here",
                        style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // If this is supposed to navigate to login page, replace it with the appropriate page.
                            // nextScreen(context, const RegisterPage());
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async {
        if (value==true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());

          // Registration successful, implement your logic here
          // For example, you can navigate to the home screen or show a success message
          // nextScreenReplace(context, HomeScreen());
        } else {
          // Registration failed, show error message
          showSnackBar(context, Colors.red, "Registration failed");
        }

        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void showSnackBar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(label: "OK", onPressed: () {}, textColor: Colors.white),
    ));
  }
}
