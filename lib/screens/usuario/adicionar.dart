import 'package:flutter/material.dart';
import 'package:GPPremium/models/usuario.dart';
import 'package:GPPremium/service/config_request.dart';
import 'dart:convert';

import '../../service/perfilapi.dart';

class AdicionarUsuariosPage extends StatefulWidget {
  final Usuario usuario;

  AdicionarUsuariosPage({this.usuario});

  @override
  _AdicionarUsuariosPageState createState() => _AdicionarUsuariosPageState();
}

class _AdicionarUsuariosPageState extends State<AdicionarUsuariosPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  bool _status = true;

  List<Perfil> _perfis = [];
  Perfil _perfilSelecionado;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfis();

    if (widget.usuario != null) {
      _nomeController.text = widget.usuario.nome;
      _loginController.text = widget.usuario.login;
      _senhaController.text = widget.usuario.senha;
      _status = widget.usuario.status ?? true;
      if (widget.usuario.perfil != null && widget.usuario.perfil.isNotEmpty) {
        _perfilSelecionado = widget.usuario.perfil[0];
      }
    }
  }

  Future<void> _carregarPerfis() async {
    try {
      List<Perfil> perfis = await PerfilApi().getAll();
      setState(() {
        _perfis = perfis;

        if (widget.usuario != null && widget.usuario.perfil.isNotEmpty) {
          _perfilSelecionado = _perfis.firstWhere(
                (p) => p.id == widget.usuario.perfil[0].id,
            orElse: () => _perfis.isNotEmpty ? _perfis[0] : null,
          );
        } else if (_perfilSelecionado == null && _perfis.isNotEmpty) {
          _perfilSelecionado = _perfis[0];
        }
      });
    } catch (e) {
      print('Erro ao carregar perfis: $e');
    }
  }


  void _salvar() async {
    if (!_formKey.currentState.validate()) return;

    setState(() => _isSaving = true);

    Usuario novoUsuario = Usuario(
      id: widget.usuario != null ? widget.usuario.id : null,
      nome: _nomeController.text,
      login: _loginController.text,
      senha: _senhaController.text,
      status: _status,
      perfil: _perfilSelecionado != null ? [_perfilSelecionado] : [],
    );

    var objData = ConfigRequest();
    var response;

    if (widget.usuario == null) {
      response = await objData.requestPost('usuario', novoUsuario.toJson());
    } else {
      response = await objData.requestUpdate('usuario', novoUsuario.toJson(), novoUsuario.id);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário salvo com sucesso!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar usuário: ${response.body}')),
      );
    }

    setState(() => _isSaving = false);
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Excluir Usuário'),
        content: Text('Tem certeza que deseja excluir este usuário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _excluirUsuario();
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _excluirUsuario() async {
    if (widget.usuario == null) return;

    setState(() => _isSaving = true);

    var objData = ConfigRequest();
    var response = await objData.delete('usuario', widget.usuario.id);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário excluído com sucesso!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir usuário: ${response.body}')),
      );
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null ? 'Adicionar Usuário' : 'Editar Usuário'),
        actions: widget.usuario != null
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _confirmarExclusao,
          ),
        ]
            : null,
      ),
      body: _isSaving
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Login'),
                validator: (value) => value.isEmpty ? 'Informe o login' : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value.isEmpty ? 'Informe a senha' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Perfil>(
                value: _perfilSelecionado,
                items: _perfis.map((perfil) {
                  return DropdownMenuItem(
                    value: perfil,
                    child: Text(perfil.descricao ?? perfil.authority),
                  );
                }).toList(),
                onChanged: (perfil) {
                  setState(() => _perfilSelecionado = perfil);
                },
                decoration: InputDecoration(labelText: 'Perfil'),
                validator: (value) =>
                value == null ? 'Selecione um perfil' : null,
              ),
              // SizedBox(height: 16),
              // SwitchListTile(
              //   title: Text('Ativo'),
              //   value: _status,
              //   onChanged: (value) => setState(() => _status = value),
              // ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
