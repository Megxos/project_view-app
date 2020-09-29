import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:project_view/ui/colors.dart';

class JoinProject extends StatefulWidget {
  @override
  _JoinProjectState createState() => _JoinProjectState();
}

class _JoinProjectState extends State<JoinProject> {
  final _formKey = new GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeDecoration = BoxDecoration(
      color: plainWhite,
      border: Border.all(color: appAccent, width: 2)
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Join Project"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Enter project code to join project"),
                Expanded(
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.info, color: secondaryColor,),
                      tooltip: "Project code is shared by project owner",)
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: PinPut(
                        fieldsCount: 5,
                      controller: _codeController,
                      validator: (value) => value.length != 5 ? "Invalid project code" : null,
                      keyboardType: TextInputType.number,
                      inputDecoration: InputDecoration(
                        filled: false,
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                      submittedFieldDecoration: BoxDecoration(
                        border: Border.all(width: 2, color: secondaryColor),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      selectedFieldDecoration: _codeDecoration,
                      followingFieldDecoration: _codeDecoration,
                    )
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.close, color: Colors.red, size: 40,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.done, color: Colors.green, size: 40,),
          onPressed: (){
            if(_formKey.currentState.validate()){
              print(_codeController.text);
            }
          },
        ),
      ],
    );;
  }
}