import 'package:GPPremium/autenticacao/login.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'factory/menu.dart';

class Ajustes extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _opacityAnimations = [];

  final List<Map<String, dynamic>> menuItems = [
    {'label': 'País', 'icon': Icons.public, 'route': '/pais', 'color': Colors.blueGrey},
    {'label': 'Camelback', 'icon': Icons.emoji_objects, 'route': '/camelback', 'color': Colors.amber},
    {'label': 'Medidas', 'icon': Icons.straighten, 'route': '/medida', 'color': Colors.deepPurple},
    {'label': 'Modelo', 'icon': Icons.precision_manufacturing, 'route': '/modelo', 'color': Colors.teal},
    {'label': 'Marca', 'icon': Icons.loyalty, 'route': '/marca', 'color': Colors.green.shade700},
    {'label': 'Matriz', 'icon': Icons.apartment, 'route': '/matriz', 'color': Colors.indigo.shade700},
    {'label': 'Antiquebra', 'icon': Icons.security, 'route': '/antiquebra', 'color': Colors.red.shade700},
    {'label': 'Espessuramento', 'icon': Icons.compress, 'route': '/espessuramento', 'color': Colors.blueGrey.shade600},
    {'label': 'Usuários', 'icon': Icons.group, 'route': '/usuarios', 'color': Colors.grey.shade800},
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < menuItems.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );

      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );

      _controllers.add(controller);
      _opacityAnimations.add(animation);

      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) controller.forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = "GP PREMIUM";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Sair"),
                value: 1,
              ),
            ],
            onSelected: (int menu) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(menuItems.length, (index) {
            final item = menuItems[index];

            return AnimatedBuilder(
              animation: _opacityAnimations[index],
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimations[index].value,
                  child: Transform.scale(
                    scale: _opacityAnimations[index].value,
                    child: GPMenu(
                      item['label'],
                      item['icon'],
                      color: item['color'], // <- aqui está o que faltava
                      onClick: () {
                        Navigator.pushNamed(context, item['route']);
                      },
                    ),
                  ),
                );
              },
            );

          }),
        ),
      ),
    );
  }
}
