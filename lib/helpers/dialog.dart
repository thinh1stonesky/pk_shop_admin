import 'package:flutter/material.dart';

Future<String?> showConfirmDialog(BuildContext context, String dispMessage) async{
  AlertDialog alertDialog = AlertDialog(
    title: const Text("Xác nhận"),
    content: Text(dispMessage),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("cancel"),
          child: const Text("Hủy")),
      ElevatedButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
          child: const Text("Ok")),
    ],
  );
  String? res = await showDialog<String?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => alertDialog);
  return res;
}


void showSnackBar(BuildContext context, String message, int second){
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: second))
  );
}