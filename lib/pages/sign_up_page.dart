import 'package:flutter/material.dart';
import 'package:word_game/data_repository/data_repository.dart';
import 'package:word_game/pages/sign_in_page.dart';

import '../services/helpers.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  bool isObscured1 = true;
  bool isObscured2 = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("WordGame",
                          style: TextStyle(
                              fontSize: 50, fontFamily: "BubblegumSans")),
                      TextFormField(
                        validator: (text) {
                          text ??= "";
                          if (!isEmail(text)) {
                            return "Incorrect email format!";
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: buildInputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.person_outline,
                                color: Colors.black26)),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (text) {
                          text ??= "";
                          if (text.length < 6) {
                            return "Password must be at least 6 characters length!";
                          } else if (text != password2Controller.text) {
                            return "Passwords must coincide";
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        controller: password1Controller,
                        obscureText: isObscured1,
                        decoration: buildInputDecoration(
                          hintText: "Password",
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.black26),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isObscured1 = !isObscured1;
                              });
                            },
                            child: Icon(
                                isObscured1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black26),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (text) {
                          text ??= "";
                          if (text.length < 6) {
                            return "Password must be at least 6 characters length!";
                          } else if (text != password1Controller.text) {
                            return "Passwords must coincide";
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        controller: password2Controller,
                        obscureText: isObscured2,
                        decoration: buildInputDecoration(
                          hintText: "Repeat Password",
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.black26),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isObscured2 = !isObscured2;
                              });
                            },
                            child: Icon(
                                isObscured2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black26),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              print("OK");
                              Map<String, dynamic> newUser = {
                                "email": emailController.text,
                                "password": password1Controller.text,
                                "confirmPassword": password2Controller.text,
                              };
                              String? token =
                                  await DataRepository().signUp(newUser);
                              print(token);
                            } else {
                              print("Not valid");
                            }
                          },
                          child: Text("Sign Up"),
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInPage(),
                              ),
                              (route) => false);
                        },
                        child: RichText(
                            text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                                children: [
                              TextSpan(text: "Already registered?"),
                              TextSpan(
                                  text: " Sign In!",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold))
                            ])),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
