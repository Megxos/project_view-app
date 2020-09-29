import 'dart:convert';
import 'package:project_view/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/services/email_validator.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/ui/progress_indicator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final User user = User();

  // signup function
  void signup() async{
    if(_formkey.currentState.validate()){
      //show progress indicator
      progressIndicator.Loading(context: context, text: "Creating account...");

      Response response = await user.signup(emailController.text, passwordController.text);
      Map body = jsonDecode(response.body);
      if(response.statusCode != 201){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: body["error"]["description"],
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: red,
            fontSize: 20.0,
         );
      }
      else{
        Navigator.pushNamed(context, "/account");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor,
                    secondaryColor
                  ],
                )
            ),
            child: SafeArea(
              child: Container(
                color: Colors.white,
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 190,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(190.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor,
                                secondaryColor
                              ],
                            )
                        ),
                        child: Center(
                          child: Text("Sign Up", style: TextStyle().copyWith(color: plainWhite, fontSize: 45.0, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child: Text("Email: ", style: TextStyle().copyWith(color: Colors.grey[800]))),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => isValidEmail(emailController.text) ? null : "invalid email",
                              decoration: InputDecoration(
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            Align(alignment: Alignment.centerLeft,child: Text("Password: ", style: TextStyle().copyWith(color: Colors.grey[800]))),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              obscuringCharacter: "•",
                              maxLength: 25,
                              validator: (value) => value.length < 6 ? "min of 6 characters" : null,
                              decoration: InputDecoration(
                                counterText: '',
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            Align(alignment: Alignment.centerLeft,child: Text("Confirm Password: ", style: TextStyle().copyWith(color: Colors.grey[800]))),
                            TextFormField(
                              controller: passwordConfirmController,
                              obscureText: true,
                              obscuringCharacter: "•",
                              maxLength: 25,
                              validator: (value) => value != passwordController.text ? "passwords don't match": null,
                              decoration: InputDecoration(
                                  counterText: '',
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            Row(
                              children: [
                                Expanded(
                                  child: ButtonTheme(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor,
                                              secondaryColor
                                            ],
                                          )
                                      ),
                                      child: FlatButton(
                                        child: Text("Sign Up", style: TextStyle().copyWith(color: plainWhite, fontWeight: FontWeight.bold),),
                                        onPressed: (){
                                         signup();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 190,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: Radius.zero, top: Radius.circular(190.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor,
                                secondaryColor
                              ],
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Already have an account?")],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  child: Text("Sign In", style: TextStyle().copyWith(color: plainWhite),),
                                  onPressed: (){
                                    Navigator.pushReplacementNamed(context, "/signin");
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
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
}
