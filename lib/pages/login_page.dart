import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_team/pages/register_page.dart';
import 'package:my_team/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/basketball_stadium.jpg"), 
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          reverse: true,
          child: Form(
                    key: formKey,
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*.30),
                      const Text(
                        "My Team",
                        style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        "Login Now", 
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400,color: Colors.white),
                        ),
                        const SizedBox(height: 50,),
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            )
                          ),
                        ),
                        const SizedBox(height: 15,),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: elevatedButtonStyle,
                            onPressed: () => login, 
                            child: const Text("Log In", style: TextStyle(fontSize: 16),)
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(children: [
                            const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.white, fontSize: 16)
                            ),
                            TextSpan(
                              text: "Register here",
                              recognizer: TapGestureRecognizer()..onTap = (){
                                nextScreen(context, const RegisterPage());
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16,decoration: TextDecoration.underline)
                            ),
                          ])
                        )
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  login(){

  }
}