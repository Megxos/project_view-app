import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/services/banks.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String _dropDownText = "Select Bank";

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
                        decoration: InputDecoration(
                            labelText: "Account NO.",
                            hintText: "0123456789",
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
                      TextFormField(
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
                              onPressed: (){},
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
