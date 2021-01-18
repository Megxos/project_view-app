import 'package:flutter/services.dart';
import 'package:project_view/ui/colors.dart';
import 'package:flutter/material.dart';
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
  void signup() async {
    if (_formkey.currentState.validate()) {
      //show progress indicator
      progressIndicator.loading(context: context, text: "Creating account...");

      await user.signup(emailController.text, passwordController.text, context);
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
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: plainWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: plainWhite,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: SingleChildScrollView(
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
                          color: plainWhite,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.zero, bottom: Radius.circular(190.0)),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
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
                                child: Text("Password: ",
                                    style: TextStyle()
                                        .copyWith(color: Colors.grey[800]))),
                            TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                obscuringCharacter: "•",
                                maxLength: 25,
                                validator: (value) => value.length < 6
                                    ? "min of 6 characters"
                                    : null,
                                decoration: _inputDecoration),
                            SizedBox(
                              height: 5.0,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Confirm Password: ",
                                    style: TextStyle()
                                        .copyWith(color: Colors.grey[800]))),
                            TextFormField(
                                controller: passwordConfirmController,
                                obscureText: true,
                                obscuringCharacter: "•",
                                maxLength: 25,
                                onEditingComplete: signup,
                                validator: (value) =>
                                    value != passwordController.text
                                        ? "passwords don't match"
                                        : null,
                                decoration: _inputDecoration),
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
                                            "Sign Up",
                                            style: TextStyle().copyWith(
                                                color: plainWhite,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: signup),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.zero, top: Radius.circular(190.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Already have an account?")],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle()
                                        .copyWith(color: primaryColor),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, "/signin");
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
