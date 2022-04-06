/**
 * Cria os menus
 */
import 'package:GPPremium/autenticacao/login.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';

import 'factory/menu.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = "GP PREMIUM";
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.black,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(), //AddCarcacaPage(),
                  ));
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            GPMenu('Carcaça', CommunityMaterialIcons.circle_double,
                onClick: () {
              Navigator.pushNamed(context, '/carcacas');
            }),
            GPMenu('Regra', Icons.gavel, onClick: () {
              Navigator.pushNamed(context, '/regras');
            }),
            GPMenu('Produção', Icons.construction, onClick: () {
              Navigator.pushNamed(context, '/producao');
            }),
            // GPMenu('Qualidade', Icons.check, onClick: () {
            //   Navigator.pushNamed(context, '/qualidade');
            // }),
            GPMenu('Ajustes', Icons.settings, onClick: () {
              Navigator.pushNamed(context, '/ajustes');
            }),

            // GPMenu('Borracha', Icons.precision_manufacturing, onClick: () {
            //   Navigator.pushNamed(context, '/producao');
            // }),
            // GPMenu('Paises', Icons.precision_manufacturing, onClick: () {
            //   Navigator.pushNamed(context, '/producao');
            // }),
          ],
        ),
      ),
    );
  }
}
