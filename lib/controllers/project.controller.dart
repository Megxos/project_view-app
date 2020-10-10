import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:project_view/models/user.dart';

Project project = Project();

class Project{
  final userBox = Hive.box<UserModel>("user");

  final String baseUrl = "http://project-view-api.herokuapp.com";
  String body;

  Future<Response> getProjects()async{
    String user_id = userBox.get(0).user_id.toString();
    String token = userBox.get(0).token;

    Response response = await get(join(baseUrl, "project", user_id), headers: { "token": token });
    print(response.body);
    return response;
  }

  Future<Response> joinProject(code)async{

    String token = userBox.get(0).token;

    Response response = await post(join(baseUrl, "project", "join"), headers: { "token": token },body: { "code": code });

    return response;
  }
}