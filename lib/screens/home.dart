import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/screens/pending.dart';
import 'package:project_view/screens/new_project.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/ui/custom_alerts.dart';
import 'package:project_view/ui/custom_appbar.dart';
import 'package:project_view/screens/completed.dart';
import 'package:project_view/screens/join_project.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_view/ui/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userBox = Hive.box<UserModel>("user");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  final GlobalKey _scaffoldKey = new GlobalKey();

  final _selectedIndex = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  final aboutDialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150,
          child: Image.asset("assets/images/logo.png"),
        ),
        Text(
          "Project View",
          style: TextStyle(fontSize: 25, color: Colors.grey[800]),
        ),
        Text("v1.0.0")
      ],
    ),
    title: Text("About"),
  );

  Widget _updateAccountDetails() {
    if (currentProjectBox.get(0).owner == userBox.get(0).userId)
      return ListTile(
        title: Text(
          "Update Account Details",
        ),
        leading: Icon(
          Icons.credit_card,
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, "/account");
        },
      );
    else
      return SizedBox();
  }

  List<Widget> _widgetOptions = [Pending(), Completed()];

  Future<void> _launchUri(dynamic url) async {
    try {
      await launch(url.toString());
    } catch (e) {
      print(e);
      customAlert.showAlert(isSuccess: false, msg: "Could not open link");
    }
  }

  final Uri _emailUri = Uri(
    scheme: "mailto",
    path: "melijah200@gmail.com",
    queryParameters: {
      "subject": "Project View App",
      "body": "I have been using Project View app and..."
    },
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: plainWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: plainWhite,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          elevation: 1,
          child: ValueListenableBuilder(
            valueListenable: currentProjectBox.listenable(),
            builder: (context, _, __) => Container(
              height: 500,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Add New Project",
                          ),
                          leading: Icon(Icons.add),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => NewProject());
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.people),
                          title: Text(
                            "Join Project",
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => JoinProject());
                          },
                        ),
                        currentProjectBox.get(0) == null
                            ? SizedBox()
                            : _updateAccountDetails(),
                        ListTile(
                            leading: Icon(
                              Icons.mail,
                            ),
                            title: Text(
                              "Contact",
                            ),
                            onTap: () async {
                              await _launchUri(_emailUri);
                            }),
                        ListTile(
                          title: Text(
                            "About",
                          ),
                          leading: Icon(
                            Icons.info_outline,
                          ),
                          onTap: () {
                            showAboutDialog(
                                applicationVersion: "1.0.0",
                                context: context,
                                applicationIcon: SizedBox(
                                  height: 70,
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                  ),
                                ),
                                applicationName: "Project View",
                                children: [
                                  Center(child: Text("Developed by:")),
                                  Center(
                                    child: FlatButton(
                                        child: Text(
                                          "Micah Elijah",
                                          style: TextStyle().copyWith(
                                            color: primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () async {
                                          await launch(
                                              "https://bit.ly/devmicah");
                                        }),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () async {
                                            await _launchUri(
                                                "https://projectview.herokuapp.com/privacy");
                                          },
                                          child: Text(
                                            "privacy policy",
                                            style: TextStyle().copyWith(
                                              fontSize: 15,
                                              color: primaryColor,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () async {
                                            await _launchUri(
                                                "https://projectview.herokuapp.com/terms");
                                          },
                                          child: Text(
                                            "terms of use",
                                            style: TextStyle().copyWith(
                                              fontSize: 15,
                                              color: primaryColor,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]);
                          },
                        ),
                      ],
                    ),
                    Container(
                      color: red,
                      child: ListTile(
                        title: Text("Sign Out",
                            style: TextStyle().copyWith(color: plainWhite)),
                        leading: Icon(
                          Icons.power_settings_new,
                          color: plainWhite,
                        ),
                        onTap: () => user.signOut(
                            context,
                            userBox
                                .get(0, defaultValue: UserModel(email: ""))
                                .email),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (_, value, __) => Column(
              children: [
                CustomAppBar(),
                _widgetOptions.elementAt(_selectedIndex.value)
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: bottomNavHeight,
          child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (_, value, __) => BottomNavigationBar(
              elevation: 8,
              currentIndex: _selectedIndex.value,
              onTap: _onItemTapped,
              selectedItemColor: primaryColor,
              unselectedItemColor: lightGrey,
              unselectedIconTheme: IconThemeData().copyWith(color: lightGrey),
              selectedIconTheme: IconThemeData(color: primaryColor),
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
        ),
      ),
    );
  }
}
