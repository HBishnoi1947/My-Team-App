import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_team/helper/helper_function.dart';
import 'package:my_team/pages/home_page.dart';
import 'package:my_team/service/auth_service.dart';

import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  final Function towardsLogin;
  final int timeInMilliSeconds;
  const RegisterPage({super.key, required this.towardsLogin, required this.timeInMilliSeconds});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: widget.timeInMilliSeconds));
  late final AnimationController _controllerScale = AnimationController(
      vsync: this,
      lowerBound: .3,
      upperBound: 1,
      duration: Duration(milliseconds: widget.timeInMilliSeconds));
  late final Animation<double> _animationFade = CurvedAnimation(
      parent: _controller, curve: Curves.fastLinearToSlowEaseIn);
  late final Animation<double> _animationScale =
      CurvedAnimation(parent: _controllerScale, curve: Curves.linear);
  late final Animation<Offset> _animationSlide =
      Tween<Offset>(begin: Offset(-2, 0), end: Offset.zero)
          .animate(_controller);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    forwardControler();
  }

  void forwardControler() {
    _controller.forward();
    _controllerScale.forward();
  }
  void reverseControler() {
    _controller.reverse();
    _controllerScale.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : ScaleTransition(
            scale: _animationScale,
            child: FadeTransition(
              opacity: _animationFade,
              child: SlideTransition(
                position: _animationSlide,
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 80),
                        child: Card(
                          color: Colors.brown.withOpacity(0.4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .10),
                                const Text(
                                  "My Team",
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: textInputDecoration.copyWith(
                                      labelText: "Full Name",
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )),
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Name cannot be empty";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: textInputDecoration.copyWith(
                                      labelText: "Email",
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      )),
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Email cannot be empty";
                                    } else if (RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return null;
                                    } else {
                                      return "Enter Valid Email";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: textInputDecoration.copyWith(
                                      labelText: "Password",
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      )),
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Password cannot be empty";
                                    } else if (value.length < 6) {
                                      return "Password length must be atleat 6";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                      style: elevatedButtonStyle,
                                      onPressed: () => register(),
                                      child: const Text(
                                        "Register",
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(
                                      text: "Already have an account? ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  TextSpan(
                                      text: "Login here",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          reverseControler();
                                          widget.towardsLogin();
                                        },
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.underline)),
                                ])),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUser(nameController.text, emailController.text,
              passwordController.text)
          .then((value) async {
        if (value == true) {
          // saving to shared preference state
          await HelperFunction.saveUserLoggedInStatus(
              true, nameController.text, emailController.text);
          nextScreenReplace(context, const HomePage());
        } else {
          mySnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
