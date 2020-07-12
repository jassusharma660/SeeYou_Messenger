import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messangerforseeyou/helper/helperFunctions.dart';
import 'package:messangerforseeyou/services/auth.dart';
import 'package:messangerforseeyou/services/database.dart';
import 'package:messangerforseeyou/widgets/widget.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethod authMethod = new AuthMethod();
  TextEditingController  emailTextEditingController = new TextEditingController();
  TextEditingController  passwordTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  
  signIn() async {
    if(formKey.currentState.validate()) {
      print("THIS IS -> 0");
      setState(() {
        isLoading = true;
      });

      await authMethod.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value) async {
print("THE VALUES->${value.toString()}");
        if(value!=null) {
          QuerySnapshot snapshotUserInfo = await databaseMethods
              .getUserByUserEmail(emailTextEditingController.text);
          print("THIS IS -> 1");

          print("2");
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          print("THIS IS -> 3");
          HelperFunctions.saveUserNameInSharedPreference(
              snapshotUserInfo.documents[0].data["name"]);
          print("THIS IS -> 4");
          HelperFunctions.saveUserEmailInSharedPreference(
              snapshotUserInfo.documents[0].data["email"]);
          print("THIS IS -> 5");

          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
        else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      child: Container(
        color: Color(0xff2143b1),
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        )),
    ) : Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            // App logo
            appBarMain(context),

            // Banner
            Image.asset("assets/images/login.png"),

            // Content
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Greeting primary
                  Text(
                    "Welcome",
                    style: GoogleFonts.spaceMono(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Greeting secondary
                  Text(
                    "Continue to a great experience.",
                    style: GoogleFonts.spaceMono(
                      fontSize: 20,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2143b1),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Email input
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        formInput(
                          context: context,
                          controller: emailTextEditingController,
                          validator: (email) {
                            return EmailValidator.validate(email)? null:"Please provide a valid email.";
                          },
                          iconUrl: "assets/images/email.png",
                          label: "Enter your email",
                          hint: "email@example.com",
                        ),

                        SizedBox(height: 20),

                        // Password Input
                        formInput(
                          context: context,
                          obscureText: true,
                          controller: passwordTextEditingController,
                          validator: (password) {
                            Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(password))
                              return 'Password is not valid.';
                            else
                              return null;
                          },
                          iconUrl: "assets/images/password.png",
                          label: "Enter your password",
                          hint: "***********",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Forgot Password
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  formButton(
                    onTap: () {
                      signIn();
                    },
                    context: context,
                    btnLabel: "Sign In",
                    btnColor: Color(0xff2143b1),
                    btnLabelColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  formButton(
                    context: context,
                    btnLabel: "Sign in with Google",
                    btnColor: Color(0xffffffff),
                    btnLabelColor: Colors.black,
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
