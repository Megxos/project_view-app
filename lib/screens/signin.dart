import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/services/email_validator.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/progress_indicator.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey = GlobalKey<FormState>();

  final userBox = Hive.box<UserModel>("user");

  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final User user = User();

  void signin()async{
    if(_formkey.currentState.validate()){

      //show progress dialog
      progressIndicator.Loading(text: "Signing In",context: context);

      Response response = await user.login(emailController.text, passwordController.text);
      Map body = jsonDecode(response.body);
      if(response.statusCode != 200){
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: body["error"]["description"],
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: red,
          fontSize: 20.0,
        );
      }

      final Map data = jsonDecode(response.body)["data"]["user"];
      UserModel newUser = UserModel(
          email: data["email"],
          user_id: data["user_id"],
          firstname: data["firstname"],
          lastname: data["lastname"],
          token: data["token"]
      );
      await userBox.clear();
      userBox.add(newUser);


      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: Text("Sign In", style: TextStyle().copyWith(fontFamily: "SFProText",color: plainWhite, fontSize: 45.0, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Align(alignment: Alignment.centerLeft,child: Text("Password: ", style: TextStyle().copyWith(color: Colors.grey[800]),)),
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
                                        child: Text("Sign In", style: TextStyle().copyWith(color: plainWhite, fontWeight: FontWeight.bold),),
                                        onPressed: (){
                                          signin();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  child: Text("forgot password?", style: TextStyle().copyWith(color: Colors.grey, fontSize: 18),),
                                  onPressed: (){},
                                )
                              ],
                            )
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