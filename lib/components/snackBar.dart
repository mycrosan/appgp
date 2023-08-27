import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@override
Widget deleteMessage(BuildContext context) {
  return SnackBar(
    content: Text('Excluído com sucesso!'),
    backgroundColor: Colors.teal,
    width: 280.0,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  );;
}
@override
Widget warningMessage(BuildContext context, String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: Colors.orangeAccent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  );;
}
@override
Widget successMessage(BuildContext context, String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: Colors.lightGreen,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  );;
}