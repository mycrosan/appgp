import 'package:GPPremium/models/usuario.dart';
import 'package:GPPremium/screens/usuario/adicionar.dart';
import 'package:GPPremium/service/usuarioapi.dart';
import 'package:flutter/material.dart';

class ListaUsuarios extends StatefulWidget {
  @override
  _ListaUsuariosPageState createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuarios> {
  List<Usuario> usuarios = [];
  final UsuarioApi usuarioApi = UsuarioApi();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    buscarUsuarios();
  }

  Future<void> buscarUsuarios() async {
    try {
      final lista = await usuarioApi.getAll();
      setState(() {
        usuarios = lista;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar usuários.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuários")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
          ? Center(child: Text("Nenhum usuário cadastrado."))
          : ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(usuario.nome ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Login: ${usuario.login ?? ''}'),
                  if (usuario.perfil != null && usuario.perfil.isNotEmpty)
                    Text('Perfil: ${usuario.perfil.map((p) => p.descricao).join(', ')}'),
                  // Text('Status: ${usuario.status == true ? "Ativo" : "Inativo"}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdicionarUsuariosPage(usuario: usuario),
                    ),
                  );
                  buscarUsuarios(); // Atualiza lista após editar
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdicionarUsuariosPage()),
          );
          buscarUsuarios(); // Atualiza lista após novo cadastro
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
