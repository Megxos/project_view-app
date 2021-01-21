import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/controllers/account.controller.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final accBox = Hive.box<AccountModel>("account");

  final _formKey = GlobalKey<FormState>();

  String _dropDownText = "Please wait";
  Map dropDownValue = {};

  String _accName = "";
  final accNoController = TextEditingController();

  Account account = Account();

  final canFetch = ValueNotifier<bool>(false);
  bool _fetchName = false;

  void addAccount() async {
    progressIndicator.loading(
        context: context, text: "Updating Account Details...");
    await account.addAccount(dropDownValue["name"], accNoController.text,
        _accName, dropDownValue["code"], context);
  }

  List bankList = [
    // default bank value
    {"name": "Select bank", "code": "000"}
  ];
  void getBanks() async {
    bankList = await account.getBanks();
    canFetch.value = true;
    _dropDownText = "Select Bank";
  }

  Color _accNoBorderColor = appAccent;

  void verifyAccount(bank, number) async {
    setState(() {
      _fetchName = true;
    });
    final Map response = await account.verifyAccount(bank, number);
    if (response["status"] == "success") {
      setState(() {
        _accName = response["data"]["account_name"];
        _fetchName = false;
      });
    } else {
      setState(() {
        _accNoBorderColor = red;
        _fetchName = false;
      });
    }
  }

  @override
  void initState() {
    getBanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accNameController = TextEditingController(text: _accName);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: plainWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: plainWhite,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            color: plainWhite,
            height: MediaQuery.of(context).size.height,
            child: ValueListenableBuilder(
              valueListenable: canFetch,
              builder: (context, _, __) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          "Add Account",
                          textScaleFactor: 2,
                          style: TextStyle().copyWith(
                            color: primaryColor,
                            fontFamily: "Sans",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "This is where you will receive all donations",
                                  style: TextStyle()
                                      .copyWith(color: Colors.grey[800]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    hintText: _dropDownText,
                                    fillColor: plainWhite,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: appAccent)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownValue = value;
                                    });
                                  },
                                  validator: (value) =>
                                      value == null ? "Invalid value" : null,
                                  items: bankList
                                      .map((bank) => DropdownMenuItem(
                                          value: bank,
                                          child: Text(bank["name"])))
                                      .toList(),
                                ),
                              ),
                              canFetch.value
                                  ? SizedBox(
                                      height: 1,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 0),
                                      child: CircularProgressIndicator(),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: accNoController,
                            maxLength: 10,
                            validator: (value) =>
                                value.length < 10 || value.length > 10
                                    ? "Invalid account number"
                                    : null,
                            onChanged: (value) {
                              if (value.length == 10) {
                                verifyAccount(dropDownValue["code"],
                                    accNoController.text);
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Account NO.",
                                hintText: "0123456789",
                                fillColor: plainWhite,
                                counterText: "",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide()
                                        .copyWith(color: _accNoBorderColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: _accNoBorderColor,
                                ))),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: false,
                                  controller: accNameController,
                                  validator: (value) =>
                                      value.length < 3 ? "Invalid name" : null,
                                  decoration: InputDecoration(
                                      labelText: "Account Name",
                                      hintText: "Account Name",
                                      fillColor: plainWhite,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: appAccent,
                                      )),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: appAccent,
                                      ))),
                                ),
                              ),
                              _fetchName
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : SizedBox(
                                      height: 1,
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "Save",
                                    style:
                                        TextStyle().copyWith(color: plainWhite),
                                  ),
                                  color: primaryColor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      addAccount();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Text("Skip"),
                                padding: EdgeInsets.zero,
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, "/home"),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
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
