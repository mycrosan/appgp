/**
 * Classe para otimizar a criação dos widgets dos menus
 */


import 'package:flutter/material.dart';

class GPMenu extends StatelessWidget {
  //const ({Key key}) : super(key: key);
  final String name;
  final IconData icon;
  final Function onClick;

  const GPMenu(this.name, this.icon, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Card(
          color: Colors.white,
          child: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 80.0),
                  Text(name),
                ]),
          )),
    );
  }
}