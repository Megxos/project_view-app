import 'package:flutter/material.dart';
import 'package:project_view/screens/new_project.dart';
import 'package:project_view/screens/home.dart';
import 'package:project_view/ui/theme.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ProjectView());
}

class ProjectView extends StatefulWidget {
  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: primaryTheme,
      routes: {
        "/": (context) => Home(),
        "/project/new": (context) => NewProject()
      },
    );
  }
}
