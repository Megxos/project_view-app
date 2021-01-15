import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_view/ui/colors.dart';

CustomAlert customAlert = CustomAlert();

class CustomAlert {
  void showAlert({bool isSuccess: true, String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        backgroundColor: isSuccess ? green : red,
        fontSize: 20.0,
        toastLength: Toast.LENGTH_LONG);
  }
}
