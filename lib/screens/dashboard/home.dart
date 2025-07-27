import 'package:GPPremium/autenticacao/login.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'factory/menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _opacityAnimations = [];

  final List<Map<String, dynamic>> menuItems = [
    {
      'label': 'Carcaça',
      'iconSvg': 'assets/images/pneu.svg', // Adicionando o caminho SVG
      'route': '/carcacas'
    },
    {
      'label': 'Regra',
      'icon': CommunityMaterialIcons.scale_balance,
      // Balança para representar regras/justiça
      'route': '/regras'
    },
    {
      'label': 'Produção',
      'icon': CommunityMaterialIcons.factory,
      // Fábrica representa bem a produção
      'route': '/producao'
    },
    {
      'label': 'Qualidade',
      'icon': CommunityMaterialIcons.check_decagram, // Selo de qualidade
      'route': '/qualidade'
    },
    {
      'label': 'Proibidas',
      'icon': CommunityMaterialIcons.close_octagon_outline,
      // Sinal de proibição
      'route': '/proibidas'
    },
    {
      'label': 'Relatório',
      'icon': CommunityMaterialIcons.file_chart, // Relatório gráfico
      'route': '/relatorio'
    },
    {
      'label': 'Ajustes',
      'icon': CommunityMaterialIcons.cog_outline,
      // Ícone clássico de configurações
      'route': '/ajustes'
    },
    {
      'label': 'Cobertura',
      'icon': Icons.layers,
      'route': '/cobertura',
      'color': Colors.brown.shade600
    },
    {
      'label': 'Resumo',
      'icon': Icons.pie_chart,
      'route': '/resumo',
      'color': Colors.brown.shade600
    },
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
                      iconSvg: item['iconSvg'],
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
