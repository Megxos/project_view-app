import 'package:flutter/material.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/models/user.dart';
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
import 'package:project_view/screens/account.dart';
import 'package:project_view/screens/profile.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final documentPath = await getApplicationDocumentsDirectory();
  await Hive.init(join(documentPath.path, "models"));
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  await Hive.openBox<UserModel>("user");
  await Hive.openBox<AccountModel>("account");
  await Hive.openBox<ProjectModel>("project");
  await Hive.openBox<ItemModel>("item");
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
      darkTheme: darkTheme,
      initialRoute: "/signin",
      routes: {
        "/": (context) => OnBoarding(),
        "/account": (context) => AccountDetails(),
        "/home": (context) => Home(),
        "/project/new": (context) => NewProject(),
        "/signin": (context) => Signin(),
        "/signup": (context)=> SignUp(),
        "/profile": (context) => Profile()
      },
    );
  }
}
