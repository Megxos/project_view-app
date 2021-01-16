import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/ui/custom_alerts.dart';
import 'package:project_view/ui/progress_indicator.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userBox = Hive.box<UserModel>("user");

  final accBox = Hive.box<AccountModel>("account");

  final projectBox = Hive.box<ProjectModel>("project");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  final itemBox = Hive.box<ItemModel>("item");

  final _formkey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();

  final lastnameController = TextEditingController();

  void updateProfile() async {
    progressIndicator.loading(text: "Updating Profile", context: context);

    Response response = await user.updateProfile(
        firstnameController.text, lastnameController.text, context);
    Navigator.pop(context);

    if (response.statusCode == 201) {
      userBox.get(0).firstName = firstnameController.text;
      userBox.get(0).lastName = lastnameController.text;
      Navigator.pop(context);
    } else {
      Map error = jsonDecode(response.body)["error"];

      customAlert.showAlert(isSuccess: false, msg: error["description"]);

      Navigator.pop(context);
    }
  }

  BoxDecoration _containerDecor = BoxDecoration(
      color: plainWhite,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: Colors.grey[200],
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0))
      ]);

  @override
  Widget build(BuildContext context) {
    UserModel _defaultUserValue = UserModel(
        email: "Not set",
        firstName: "Not set",
        lastName: "Not set",
        token: "Not set");

    final currentUser = userBox.get(0, defaultValue: _defaultUserValue);

    String email = currentUser.email;
    String firstname = currentUser.firstName;
    String lastname = currentUser.lastName;

    AccountModel _defaultValue =
        AccountModel(accBank: "Not set", accName: "Not set", accNo: "Not set");

    final accDetails = accBox.get(
        currentProjectBox.get(0, defaultValue: CurrentProject(id: 0)).id,
        defaultValue: _defaultValue);
    String accBank = accDetails.accBank;
    String accNo = accDetails.accNo;
    String accName = accDetails.accName;

    final editProfile = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AlertDialog(
          title: Text("Edit Profile"),
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstnameController,
                  validator: (value) =>
                      value.length <= 3 ? "min of 3 chars" : null,
                  decoration: InputDecoration(labelText: "Firstname"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: lastnameController,
                  validator: (value) =>
                      value.length <= 3 ? "min of 3 chars" : null,
                  decoration: InputDecoration(labelText: "Lastname"),
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.green,
                size: 40,
              ),
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  updateProfile();
                }
              },
            ),
          ],
        ));

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle().copyWith(color: plainWhite),
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 50.0, horizontal: 0),
                      decoration: _containerDecor,
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: secondaryColor,
                              child: Icon(
                                Icons.person_outline,
                                size: 50,
                              ),
                              radius: 50,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(email),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: _containerDecor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Profile",
                                  style:
                                      TextStyle().copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Firstname:"),
                                Text(
                                  firstname,
                                  style: TextStyle().copyWith(color: lightGrey),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Lastname:"),
                                Text(lastname,
                                    style:
                                        TextStyle().copyWith(color: lightGrey))
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: offWhite,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: lightGrey,
                                      size: 17.0,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => editProfile);
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Project Account Details",
                                  style: TextStyle().copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Name: "),
                                Expanded(
                                  child: Text(
                                    accName,
                                    style:
                                        TextStyle().copyWith(color: lightGrey),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Number: "),
                                Text(accNo,
                                    style:
                                        TextStyle().copyWith(color: lightGrey))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Bank: "),
                                Expanded(
                                    child: Text(
                                  accBank,
                                  style: TextStyle().copyWith(color: lightGrey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: offWhite,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: lightGrey,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/account");
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8.0),
                          onPressed: () => user.signOut(context, email),
                          icon: Icon(
                            Icons.power_settings_new,
                            color: plainWhite,
                          ),
                          label: Text(
                            "Sign Out",
                            style: TextStyle().copyWith(color: plainWhite),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
