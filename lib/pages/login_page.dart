import 'package:flutter/material.dart';
import 'package:my_team/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final formKey = GlobalKey<FormState>();
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
                            onPressed: (){}, 
                            child: Text("Log In")
                            ),
                        )
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}