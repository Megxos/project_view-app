import 'package:flutter/material.dart';
import 'package:project_view/screens/pending.dart';
import 'package:project_view/screens/new_project.dart';
import 'package:project_view/ui/custom_appbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    Text("Completed")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Project View", style: TextStyle(color: Colors.white, fontSize: 25)),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.indigo[500],
                  Colors.blue
                ])
              ),
            ),
            ListTile(title: Text("Add New Project"),leading: Icon(Icons.add),onTap: (){
              Navigator.pop(context);
              showDialog(context: context, builder: (context)=> NewProject());
            },),
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
      body: Column(
        children: [
          CustomAppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Column(
              children: [
                SingleChildScrollView(child: _widgetOptions.elementAt(_selectedIndex)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}