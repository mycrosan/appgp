import 'package:flutter/material.dart';

class GPMenu extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onClick;

  const GPMenu(
      this.name,
      this.icon, {
        Key key,
        @required this.onClick,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 80, semanticLabel: name),
              SizedBox(height: 8),
              Text(name, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
