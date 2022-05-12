import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@override
Widget cicleLoading(BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 30.0),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [CircularProgressIndicator()],
      ));
}
