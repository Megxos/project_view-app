import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:project_view/ui/theme.dart';

part 'app_config.g.dart';

AppConfig appConfig = AppConfig();

@HiveType(typeId: 4)
class AppConfig{
  @HiveField(0)
  bool isFirstTimeUser;

  @HiveField(1)
  ThemeData theme;

  AppConfig({this.isFirstTimeUser });

  init()async{
    // await Hive.openBox<AppConfig>("config");
    final configBox = Hive.box<AppConfig>("config");

    print(configBox.get(0).isFirstTimeUser);

    if(configBox.get(0) == null){
      configBox.add(AppConfig(isFirstTimeUser: true));
    }
  }
}