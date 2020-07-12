import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messangerforseeyou/helper/helperFunctions.dart';
import 'package:messangerforseeyou/services/auth.dart';
import 'package:messangerforseeyou/services/database.dart';
import 'package:messangerforseeyou/view/chatRoomScreen.dart';
import 'package:messangerforseeyou/widgets/widget.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController  userNameTextEditingController = new TextEditingController();
  TextEditingController  emailTextEditingController = new TextEditingController();
  TextEditingController  passwordTextEditingController = new TextEditingController();

  signMeUp() {
    if(formKey.currentState.validate()) {

      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };

      setState(() {
        isLoading = true;
      });

      authMethod.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
          .then((value) {
        //print("$value.userId");

        databaseMethods.uploadUserInfo(userInfoMap);

        HelperFunctions.saveUserEmailInSharedPreference(emailTextEditingController.text);
        HelperFunctions.saveUserNameInSharedPreference(userNameTextEditingController.text);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Container(
        child: Container(
            color: Color(0xff2143b1),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )),
      ) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            // App logo
            appBarMain(context),

            // Banner
            Image.asset("assets/images/register.png"),

            // Content
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Greeting primary
                  Text(
                    "Welcome to the party!",
                    style: GoogleFonts.spaceMono(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Greeting secondary
                  Text(
                    "Register to be a part of this journey.",
                    style: GoogleFonts.spaceMono(
                      fontSize: 17,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2143b1),
                    ),
                  ),

                  SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        // Username input
                        formInput(
                          context: context,
                          controller: userNameTextEditingController,
                          validator: (username) {
                            Pattern pattern =
                                r'^[A-Za-z0-9]+(?:[ -][A-Za-z0-9]+)*$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(username))
                              return "Please provide a valid username.";
                            else
                              return null;
                          },
                          iconUrl: "assets/images/username.png",
                          label: "Enter your Username",
                          hint: "User_name",
                        ),

                        SizedBox(height: 20),

                        // Email input
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
                          controller: passwordTextEditingController,
                          obscureText: true,
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

                  formButton(
                    context: context,
                    btnLabel: "Sign Up",
                    onTap: () {
                      signMeUp();
                    },
                    btnColor: Color(0xff2143b1),
                    btnLabelColor: Colors.white,
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already a member? ",
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
                          "Login Now",
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
