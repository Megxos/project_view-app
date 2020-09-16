import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/services/email_validator.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  void signin(){
    if(_formkey.currentState.validate()){
      Navigator.pushNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(200.0)),
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
                          child: Text("Sign In", style: TextStyle().copyWith(color: plainWhite, fontSize: 45.0, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => isValidEmail(emailController.text) ? null : "invalid email",
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "email"
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              obscuringCharacter: "•",
                              maxLength: 25,
                              validator: (value) => value.length < 6 ? "min of 6 characters" : null,
                              decoration: InputDecoration(
                                  counterText: '',
                                  labelText: "Password",
                                  hintText: "password"
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            Row(
                              children: [
                                Expanded(
                                  child: ButtonTheme(
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
                                        child: Text("Sign In", style: TextStyle().copyWith(color: plainWhite),),
                                        onPressed: (){
                                          signin();
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
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: Radius.zero, top: Radius.circular(200.0)),
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
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Don't have an account?")],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  child: Text("Sign Up", style: TextStyle().copyWith(color: plainWhite),),
                                  onPressed: (){
                                    Navigator.pushReplacementNamed(context, "/signup");
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
