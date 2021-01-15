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
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: Column(
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
                  )),
            ));
  }
}
