import 'package:flutter/material.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/models/app_config.dart';
import 'package:project_view/models/completed.dart';
import 'package:project_view/models/current_project.dart';
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
import 'package:project_view/ui/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final documentPath = await getApplicationDocumentsDirectory();
  Hive.init(join(documentPath.path, "models"));
  Hive.registerAdapter(AppConfigAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(CurrentProjectAdapter());
  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(CompletedItemAdapter());
  await Hive.openBox<AppConfig>("config");
  await Hive.openBox<UserModel>("user");
  await Hive.openBox<AccountModel>("account");
  await Hive.openBox<ProjectModel>("project");
  await Hive.openBox<CurrentProject>("current_project");
  await Hive.openBox<ItemModel>("item");
  await Hive.openBox<CompletedItem>("completed");
  return runApp(ProjectView());
}

class ProjectView extends StatefulWidget {
  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {

  final configBox = Hive.box<AppConfig>("config");

  final userBox = Hive.box<UserModel>("user");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: primaryColor,
        systemNavigationBarColor: primaryColor
      )
    );

    // initialize config holding user settings
    appConfig.init();
  // check if user is a first time user
    bool isFirstTimeUser = configBox.get(0).isFirstTimeUser;

    String firstScreen = "/onboarding";

    if(!isFirstTimeUser && userBox.get(0) == null){
      firstScreen = "/signin";
    }else if(userBox.get(0) != null){
      firstScreen = "/home";
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: primaryTheme,
      initialRoute: firstScreen,
      routes: {
        "/home": (context) => Home(),
        "/account": (context) => AccountDetails(),
        "/onboarding": (context) => OnBoarding(),
        "/project/new": (context) => NewProject(),
        "/signin": (context) => Signin(),
        "/signup": (context)=> SignUp(),
        "/profile": (context) => Profile()
      },
    );
  }
}
