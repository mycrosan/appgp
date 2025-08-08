import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GPMenu extends StatelessWidget {
  final String name;
  final dynamic icon; // Pode ser IconData ou Widget
  final String iconSvg;
  final VoidCallback onClick;
  final Color color;

  const GPMenu(
      this.name,
      this.icon, {
        Key key,
        this.iconSvg,
        @required this.onClick,
        this.color = Colors.black,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (iconSvg != null) {
      iconWidget = SvgPicture.asset(
        iconSvg,
        width: 60,
        height: 60,
        color: color,
      );
    } else if (icon is IconData) {
      iconWidget = Icon(
        icon,
        size: 60,
        semanticLabel: name,
        color: color,
      );
    } else if (icon is Widget) {
      iconWidget = icon;
    } else {
      iconWidget = Icon(Icons.help_outline, size: 60, color: color); // fallback
    }

    return InkWell(
      onTap: onClick,
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(fontSize: 12, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
