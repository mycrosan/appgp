import 'package:GPPremium/autenticacao/login.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GPPremium/service/usuarioapi.dart';
import 'package:GPPremium/models/usuario.dart';
import 'factory/menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _opacityAnimations = [];
  String nomeUsuario = '';
  final UsuarioApi usuarioApi = UsuarioApi();

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
    {
      'label': 'Cola',
      'iconSvg': 'assets/images/cola.svg',
      'route': '/cola',
      'color': Colors.brown.shade600
    },
    {
      'label': 'Ajustes',
      'icon': CommunityMaterialIcons.cog_outline,
      'route': '/ajustes'
    },
  ];

  @override
  void initState() {
    super.initState();
    _buscarDadosUsuario();

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

  /// Busca os dados do usuário logado
  Future<void> _buscarDadosUsuario() async {
    try {
      final usuario = await usuarioApi.me();
      if (mounted) {
        setState(() {
          nomeUsuario = usuario.nome ?? '';
        });
      }
    } catch (e) {
      // Em caso de erro, mantém o nome vazio
      print('Erro ao buscar dados do usuário: $e');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text("GP PREMIUM"),
            if (nomeUsuario.isNotEmpty) ...[
              SizedBox(width: 16),
              Text(
                "Olá $nomeUsuario!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
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
