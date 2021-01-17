import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/services/email_validator.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/ui/progress_indicator.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final User user = User();

  String _progressText = "Signing In";

  void signin() async {
    if (_formkey.currentState.validate()) {
      //show progress dialog
      progressIndicator.loading(text: _progressText, context: context);
      await user.login(emailController.text, passwordController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration _inputDecoration = InputDecoration(
      counterText: "",
      fillColor: plainWhite,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2)),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: plainWhite,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: plainWhite),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: SingleChildScrollView(
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
                        borderRadius: BorderRadius.vertical(
                            top: Radius.zero, bottom: Radius.circular(200.0)),
                      ),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle().copyWith(
                              color: primaryColor,
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Email: ",
                                  style: TextStyle()
                                      .copyWith(color: Colors.grey[800]))),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                isValidEmail(emailController.text)
                                    ? null
                                    : "invalid email",
                            decoration: _inputDecoration,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password: ",
                                style: TextStyle()
                                    .copyWith(color: Colors.grey[800]),
                              )),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            obscuringCharacter: "•",
                            maxLength: 25,
                            validator: (value) =>
                                value.length < 6 ? "min of 6 characters" : null,
                            decoration: _inputDecoration,
                            onEditingComplete: signin,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonTheme(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        gradient: LinearGradient(
                                          colors: [
                                            primaryColor,
                                            secondaryColor
                                          ],
                                        )),
                                    child: FlatButton(
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle().copyWith(
                                              color: plainWhite,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: signin),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Text(
                                  "forgot password?",
                                  style: TextStyle().copyWith(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                onPressed: () {},
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.zero, top: Radius.circular(200.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Don't have an account?")],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Text(
                                  "Sign Up",
                                  style:
                                      TextStyle().copyWith(color: primaryColor),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/signup");
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
    );
  }
}
