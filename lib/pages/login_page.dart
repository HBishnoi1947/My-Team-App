import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_team/pages/register_page.dart';
import 'package:my_team/service/databases_service.dart';
import 'package:my_team/widgets/widgets.dart';

import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final Function towardsRegister;
  final int timeInMilliSeconds;
   LoginPage({super.key, required this.towardsRegister, required this.timeInMilliSeconds});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.timeInMilliSeconds));
    late final AnimationController _controllerScale = AnimationController(vsync: this,lowerBound: 0.3,upperBound: 1, duration: Duration(milliseconds: widget.timeInMilliSeconds));
  late final Animation<double> _animationFade = CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn);
  late final Animation<double> _animationScale = CurvedAnimation(parent: _controllerScale, curve: Curves.linear);
  late final Animation<Offset> _animationSlide = Tween<Offset>(begin: Offset(-2, 0), end: Offset.zero).animate(_controller);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthService authService = AuthService();
  

  @override
  void initState() {
    super.initState();
    forwardControler();
  }

  void forwardControler(){
    _controller.forward();
    _controllerScale.forward();
  }
  void reverseControler(){
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
    
    return ScaleTransition(
      scale: _animationScale,
      child: FadeTransition(
        opacity: _animationFade,
        child: SlideTransition(
          position: _animationSlide,
          textDirection: TextDirection.ltr,
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
                              validator: (value) {
                                    if(value==null || value =="") {
                                      return "Email cannot be empty";
                                    } else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                      return null;
                                    }
                                    else{
                                      return "Enter Valid Email";
                                    }
                                  },
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
                                onPressed: () => login(), 
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
                                    reverseControler();
                                    widget.towardsRegister();
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
        ),
      ),
    );
  }

  login() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginUser(
        emailController.text,
        passwordController.text
        ).then((value) async{
          if(value==true){
            // getting data from firebase
            QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(emailController.text);
            
            // saving to shared preference state
            await HelperFunction.saveUserLoggedInStatus(true, snapshot.docs[0]["fullName"], snapshot.docs[0]["email"]);


            nextScreenReplace(context, const HomePage());
          }
          else{
            mySnackbar(context, Colors.red, value);
            setState(() {
              _isLoading=false;
            });
          }
        });
    }
  }
}