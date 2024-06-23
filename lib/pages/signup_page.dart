import 'package:flutter/material.dart';
import 'package:quickchat/auth/auth_gate.dart';
import 'package:quickchat/auth/auth_service.dart';
import 'package:quickchat/components/my_input_field.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final pwdController=TextEditingController();
  final cpwdController=TextEditingController();

  void signup(BuildContext context)async{
    final authService=AuthService();
    if(pwdController.text==cpwdController.text) {
      try{
        await authService.signup(emailController.text, pwdController.text,nameController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthGate()),
        );
      } catch(e){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Signup Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Error'),
          content: Text("Password and confirm Password does not match"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //1 logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.purple,
                ),

                const SizedBox(height: 25),

                //2 app name

                const Text(
                  "Q u i c k C h a t",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                //3 email
                const SizedBox(height: 50),
                MyTextField(controller: nameController, obscureText: false,label: "Name",),
                const SizedBox(height: 10,),
                MyTextField(controller: emailController, obscureText: false,label: "Email",),

                //4 password
                const SizedBox(height: 10,),
                MyTextField(controller: pwdController, obscureText: true,label: "Password",),

                const SizedBox(height: 10,),
                MyTextField(controller: cpwdController, obscureText: true,label: "Confirm Password",),

                //6 sign in button
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () => signup(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(25),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                //7 register here
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",style: TextStyle(color: Colors.black),),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login_page');
                      },
                      child: const Text(" Login Here",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}