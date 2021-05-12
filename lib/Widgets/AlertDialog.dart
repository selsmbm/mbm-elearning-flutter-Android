import 'package:flutter/material.dart';

showAlertofError(BuildContext context, String errors,) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("😔 Error"),
    content: Text("$errors"),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("⚠ Worning"),
    content: Text("Please fill all the details"),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSuccessAlert(BuildContext context,massage) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("😃 Success"),
    content: Text(massage),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
