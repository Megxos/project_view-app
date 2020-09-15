import 'package:flutter/material.dart';
import 'package:project_view/services/project.dart';
import 'package:project_view/ui/custom_appbar.dart';

class NewProject extends StatelessWidget {
  final  _formKey = GlobalKey<FormState>();
  final projectNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Project"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: projectNameController,
              validator: (value)=> value.length < 3 ?"min of 3 characters" : null,
              decoration: InputDecoration(
                hintText: "Project name",
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: Colors.indigo[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Add Project",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        newProject(Project(name: projectNameController.text, isCompleted: false));
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class sub extends CustomAppBar{
  CustomAppBar parent;
}