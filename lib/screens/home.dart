import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  final GlobalKey _scaffoldKey = new GlobalKey();

  int _selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final aboutDialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Project View", style: TextStyle(fontSize: 25, color: Colors.grey[800]),),
        Text("v1.0.0")
      ],
    ),
    title: Text("About"),
  );

  List<Widget> _widgetOptions = [
    Pending(),
    Completed()
  ];

  @override
  Widget build(BuildContext context) {

    String email = userBox.get(0).email;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Project View", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          tooltip: "Close drawer",
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/profile");
                              },
                              child: Stack(
                                overflow: Overflow.visible,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      backgroundColor: secondaryColor,
                                      child: Icon(Icons.person_outline, size: 50,),
                                      radius: 50,
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
                                    child: IconButton(
                                      icon: Icon(Icons.edit, color: Colors.white,), onPressed: () {  },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(email, style: TextStyle().copyWith(color: plainWhite),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.indigo[500],
                    Colors.blue
                  ])
                ),
              ),
            ),
            ListTile(title: Text("Add New Project"),leading: Icon(Icons.add),onTap: (){
              Navigator.pop(context);
              showDialog(context: context, builder: (context)=> NewProject());
            },),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Join Project"),
              onTap: (){
                Navigator.pop(context);
                showDialog(context: context, builder: (context) => JoinProject());
              },
            ),
            ListTile(
              title: Text("Update Account Details"),
              leading: Icon(Icons.credit_card),
              onTap: (){
                Navigator.pushReplacementNamed(context, "/account");
              },
            ),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.info_outline),
              onTap: (){
                Navigator.pop(context);
                showDialog(context: context, builder: (context) => aboutDialog);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(),
            _widgetOptions.elementAt(_selectedIndex)
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 69,
        child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.hourglass_empty, color: Colors.indigo[500],),
                  title: Text("Pending", style: TextStyle(color: Colors.indigo[500]),),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.done, color: Colors.indigo[500],),
                  title: Text("Completed", style: TextStyle(color: Colors.indigo[500]),
                  ))
        ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          unselectedFontSize: 20,
        ),
      ),
    );
  }
}
