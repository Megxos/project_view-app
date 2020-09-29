import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/services/banks.dart';
import 'package:project_view/controllers/account.controller.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {

  final accBox = Hive.box<AccountModel>("account");

  final _formKey = GlobalKey<FormState>();

  String _dropDownText = "Select Bank";
  final accNoController = TextEditingController();
  final accNameController = TextEditingController();
  Account account = Account();

  void addAccount()async{
    progressIndicator.Loading(context: context, text: "Updating Account Details...");
    Response response = await account.addAccount(_dropDownText, accNoController.text, accNameController.text);
    if(response.statusCode != 201){
      Navigator.pop(context);
      final error = jsonDecode(response.body)["error"];

      Fluttertoast.showToast(
        msg: error["description"],
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 20,
        backgroundColor: red
      );
    }
    else{
      final data = jsonDecode(response.body)["data"];
      print(data["data"]["acc_no"]);

      AccountModel account = AccountModel(
        id: data["data"]["acc_id"],
        acc_name: data["data"]["acc_name"],
        acc_no: data["data"]["acc_no"],
        acc_bank: data["data"]["acc_bank"]
      );

      await accBox.clear();
      accBox.add(account);

      print(accBox.get(0).acc_no);
      Fluttertoast.showToast(
          msg:  data["description"],
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: green,
          fontSize: 20
      );
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/home");
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
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    child: Text("Add Account", textScaleFactor: 2, style: TextStyle().copyWith(color: plainWhite, fontFamily: "Sans", fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("This is where you will receive all donations", style: TextStyle().copyWith(color: Colors.grey[800]),),
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: appAccent, width: 2.0)
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Text(_dropDownText),
                                    items: banks.map((bank) =>
                                        DropdownMenuItem(
                                            value: bank,
                                            child: Text(bank.name)
                                        )
                                    ).toList(),
                                    onChanged: (value){
                                      setState(() {
                                        _dropDownText = value.name;
                                      });
                                    }
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: accNoController,
                        maxLength: 10,
                        validator: (value) => value.length < 10 || value.length > 10 ? "Invalid account number" : null,
                        decoration: InputDecoration(
                            labelText: "Account NO.",
                            hintText: "0123456789",
                            fillColor: plainWhite,
                            counterText: "",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: appAccent,
                                    width: 2
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: appAccent,
                                    width: 2
                                )
                            )
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: accNameController,
                        validator: (value) => value.length < 3 ? "Invalid name" : null,
                        decoration: InputDecoration(
                            labelText: "Account Name",
                            hintText: "Account Name",
                          fillColor: plainWhite,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appAccent,
                              width: 2
                            )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: appAccent,
                                  width: 2
                              )
                          )
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                              child: Text("Save", style: TextStyle().copyWith(color: plainWhite),),
                              color: primaryColor,
                              onPressed: (){
                                if(_formKey.currentState.validate()){
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
                            child:
                            Row(
                                children: [
                                  Text("Skip"),
                                  Icon(Icons.arrow_forward,),
                                ]
                            ),padding: EdgeInsets.zero,onPressed: (){ Navigator.pushReplacementNamed(context, "/home"); },),
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
    );
  }
}
