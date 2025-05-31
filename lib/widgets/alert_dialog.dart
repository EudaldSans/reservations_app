import 'package:flutter/material.dart';


showAlertDialog(BuildContext context, String warning, final void Function() onConfirm) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(10),
    );

    final ButtonStyle confirmButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(10),
    );

    // set up the buttons
    Widget cancelButton = TextButton(
      style: flatButtonStyle,
      child: Text("Cancel", style: TextStyle(color: Colors.black)),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget launchButton = TextButton(
      style: confirmButtonStyle,
      child: Text("Confirm", style: TextStyle(color: Colors.white)),
      onPressed:  () {
        onConfirm();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Careful!"),
      content: Text(warning),
      actions: [
        cancelButton,
        launchButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }