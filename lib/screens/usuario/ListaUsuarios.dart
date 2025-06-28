import 'dart:convert';
import 'package:GPPremium/main.dart';
import 'package:GPPremium/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'adicionar.dart';


class ListaUsuariosPage extends StatefulWidget {
  @override
  _ListaUsuariosPageState createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    buscarUsuarios();
  }

  Future<void> buscarUsuarios() async {
    final response = await http.get(Uri.parse(SERVER_IP + "usuario"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        usuarios = data.map((e) => Usuario.fromJson(e)).toList();
      });
    } else {
      print("Erro ao buscar usuários");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuários")),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario.nome),
            subtitle: Text(usuario.login),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarUsuariosPage()),
          );
          buscarUsuarios(); // atualiza a lista após adicionar
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
