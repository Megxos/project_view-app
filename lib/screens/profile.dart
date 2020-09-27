import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/main.dart';
import 'package:project_view/ui/theme.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final _formkey = GlobalKey <FormState>();

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();

  bool _switchState = true;
  @override
  Widget build(BuildContext context) {

    final editProfile = AlertDialog(
      title: Text("Edit Profile"),
      content: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: firstnameController,
              validator: (value) => value.length <= 3 ? "min of 3 chars" : null,
              decoration: InputDecoration(
                labelText: "Firstname"
              ),
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: lastnameController,
              validator: (value) => value.length <= 3 ? "min of 3 chars" : null,
              decoration: InputDecoration(
                labelText: "Lastname"
              ),
            )
          ],
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.close, color: Colors.red, size: 40,),onPressed: (){Navigator.pop(context);},),
        IconButton(
          icon: Icon(Icons.done, color: Colors.green, size: 40,),
          onPressed: (){
            if(_formkey.currentState.validate()){
              Navigator.pop(context);
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle().copyWith(color: plainWhite),),
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        )
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 30.0,),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: Icon(Icons.person_outline, size: 50,),
                      radius: 50,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("melijah200@gmail.com"),
                  SizedBox(height: 30,),
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 0),
                   child: Column(
                     children: [
                       Row(
                         children: [
                           Text("Profile", style: TextStyle().copyWith(color: Colors.grey),),
                         ],
                       ),
                       Divider(),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Firstname:"),
                           Text(" Micah")
                         ],
                       ),
                       SizedBox(height: 10,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Lastname:"),
                           Text(" Elijah")
                         ],
                       ),
                       SizedBox(height: 10.0,),
                       Row(children: [
                         Expanded(
                           child: RaisedButton(
                             child: Icon(Icons.edit, color: appAccent,),
                             color: Colors.white,
                             elevation: 0.5,
                             onPressed: (){
                               showDialog(context: context, builder: (context) => editProfile);
                             },
                           ),
                         )
                       ],
                       ),
                       SizedBox(height: 20.0,),
                       Row(
                         children: [
                           Text("Account Details", style: TextStyle().copyWith(fontWeight: FontWeight.normal, color: Colors.grey),),
                         ],
                       ),
                       Divider(),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Name: "),
                           Text("Micah Iliya")
                         ],
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Number: "),
                           Text("0463040482")
                         ],
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Bank: "),
                           Expanded(child: Text("Guaranty Trust Bank", overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.right,))
                         ],
                       ),
                       SizedBox(height: 10,),
                       Row(children: [
                         Expanded(
                           child: RaisedButton(
                             child: Icon(Icons.edit, color: appAccent,),
                             color: Colors.white,
                             elevation: 0.5,
                             onPressed: (){
                               Navigator.pushNamed(context, "/account");
                             },
                           ),
                         )
                       ],
                       ),
                     ],
                   ),
                 )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: FlatButton.icon(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                          onPressed: (){},
                          icon: Icon(Icons.power_settings_new, color: plainWhite,),
                          label: Text("Sign Out", style: TextStyle().copyWith(color: plainWhite),),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
