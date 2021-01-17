import 'package:flutter/material.dart';
import 'package:project_view/controllers/project.controller.dart';
import 'package:project_view/ui/progress_indicator.dart';

class NewProject extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
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
              validator: (value) =>
                  value.length < 3 ? "min of 3 characters" : null,
              decoration: InputDecoration(
                hintText: "Project name",
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: Colors.indigo[500],
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        progressIndicator.loading(
                            text: "Creating project", context: context);
                        await project.newProject(projectNameController.text);
                        Navigator.pop(context);
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
