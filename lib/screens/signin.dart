import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/services/email_validator.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/ui/custom_alerts.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUri(dynamic url) async {
    try {
      await launch(url.toString());
    } catch (e) {
      print(e);
      customAlert.showAlert(isSuccess: false, msg: "Could not open link");
    }
  }

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
      contentPadding: EdgeInsets.all(20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: plainWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: plainWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.zero,
                              bottom: Radius.circular(200.0),
                            ),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                                validator: (value) => value.length < 6
                                    ? "min of 6 characters"
                                    : null,
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
                                          horizontal: 10.0, vertical: 20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
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
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.zero,
                                top: Radius.circular(200.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle().copyWith(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle()
                                          .copyWith(color: primaryColor),
                                    ),
                                    onPressed: () =>
                                        Navigator.pushReplacementNamed(
                                            context, "/signup"),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    onPressed: () async {
                                      await _launchUri(
                                          "https://projectview.herokuapp.com/privacy");
                                    },
                                    child: Text(
                                      "privacy policy",
                                      style: TextStyle().copyWith(
                                        fontSize: 15,
                                        color: primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
