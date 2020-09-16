import 'package:flutter/material.dart';
import 'package:project_view/screens/new_project.dart';
import 'package:project_view/screens/home.dart';
import 'package:project_view/ui/theme.dart';
import 'package:flutter/services.dart';
import 'package:project_view/screens/signup.dart';
import 'package:project_view/screens/signin.dart';
import 'package:project_view/screens/onboarding.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final documentPath = await getApplicationDocumentsDirectory();
  await Hive.init(join(documentPath.path, "services"));
  runApp(ProjectView());
}

class ProjectView extends StatefulWidget {
  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  void initState(){
    super.initState();
  }
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
        "/": (context) => OnBoarding(),
        "/home": (context) => Home(),
        "/project/new": (context) => NewProject(),
        "/signin": (context) => Signin(),
        "/signup": (context)=> SignUp()
      },
    );
  }
}
