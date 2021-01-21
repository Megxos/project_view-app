import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';

ProgressIndicator progressIndicator = ProgressIndicator();

class ProgressIndicator {
  BuildContext context;

  void loading({context, text = "Please wait"}) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(appAccent),
                  strokeWidth: 7,
                ),
              ],
            )));
  }
}
