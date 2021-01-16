import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';

ProgressIndicator progressIndicator = ProgressIndicator();

class ProgressIndicator {
  BuildContext context;

  void loading({context, text = "Please wait"}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(appAccent),
                  strokeWidth: 9,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  text,
                  style: TextStyle().copyWith(color: plainWhite),
                )
              ],
            )));
  }
}
