import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/screens/pending.dart';
import 'package:project_view/screens/new_project.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/ui/custom_appbar.dart';
import 'package:project_view/screens/completed.dart';
import 'package:project_view/screens/join_project.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userBox = Hive.box<UserModel>("user");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  final GlobalKey _scaffoldKey = new GlobalKey();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final aboutDialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Project View",
          style: TextStyle(fontSize: 25, color: Colors.grey[800]),
        ),
        Text("v1.0.0")
      ],
    ),
    title: Text("About"),
  );

  List<Widget> _widgetOptions = [Pending(), Completed()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 0,
        child: Container(
          height: 500,
          color: primaryColor,
          child: Column(
            children: [
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Project View",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          tooltip: "Close drawer",
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    // SizedBox(height: 20,),
                    // Column(
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: (){
                    //             Navigator.pop(context);
                    //             Navigator.pushNamed(context, "/profile");
                    //           },
                    //           child: Stack(
                    //             overflow: Overflow.visible,
                    //             children: [
                    //               Container(
                    //                 child: CircleAvatar(
                    //                   backgroundColor: plainWhite,
                    //                   child: Icon(Icons.person_outline, size: 50,),
                    //                   radius: 60,
                    //                 ),
                    //               ),
                    //               // Positioned(
                    //               //     top: 0,
                    //               //     right: 0,
                    //               //     child: CircleAvatar(
                    //               //       backgroundColor: secondaryColor,
                    //               //       child: IconButton(
                    //               //         icon: Icon(Icons.edit, color: plainWhite,), onPressed: () {  },
                    //               //       ),
                    //               //     )
                    //               // ),
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //     SizedBox(height: 10,),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(email, style: TextStyle().copyWith(color: plainWhite),)
                    //       ],
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Divider(color: plainWhite, height: 70,),
              ListTile(
                title: Text(
                  "Add New Project",
                  style: TextStyle().copyWith(color: plainWhite),
                ),
                leading: Icon(Icons.add, color: plainWhite),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context, builder: (context) => NewProject());
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: plainWhite),
                title: Text("Join Project",
                    style: TextStyle().copyWith(color: plainWhite)),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context, builder: (context) => JoinProject());
                },
              ),
              currentProjectBox.get(0) == null
                  ? SizedBox()
                  : ListTile(
                      title: Text("Update Account Details",
                          style: TextStyle().copyWith(color: plainWhite)),
                      leading: Icon(Icons.credit_card, color: plainWhite),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/account");
                      },
                    ),
              ListTile(
                leading: Icon(Icons.mail, color: plainWhite),
                title: Text("Contact",
                    style: TextStyle().copyWith(color: plainWhite)),
                onTap: () {},
              ),
              ListTile(
                title: Text("About",
                    style: TextStyle().copyWith(color: plainWhite)),
                leading: Icon(
                  Icons.info_outline,
                  color: plainWhite,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context, builder: (context) => aboutDialog);
                },
              ),
              ListTile(
                title: Text("Sign Out",
                    style: TextStyle().copyWith(color: plainWhite)),
                leading: Icon(
                  Icons.power_settings_new,
                  color: plainWhite,
                ),
                onTap: () => user.signOut(context),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [CustomAppBar(), _widgetOptions.elementAt(_selectedIndex)],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 68,
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: plainWhite,
          unselectedItemColor: Colors.grey[300],
          unselectedIconTheme: IconThemeData().copyWith(color: offWhite),
          selectedIconTheme: IconThemeData(color: plainWhite),
          unselectedFontSize: 15,
          selectedFontSize: 15,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_empty),
              activeIcon: Icon(Icons.hourglass_full),
              label: "Pending",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.done),
                activeIcon: Icon(Icons.done_all_outlined),
                label: "Completed")
          ],
        ),
      ),
    );
  }
}
