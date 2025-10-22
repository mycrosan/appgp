import 'dart:convert';
import 'package:GPPremium/models/usuario.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'config_request.dart';

class UsuarioApi extends ChangeNotifier {
  static const ENDPOINT = 'usuario';

  Future<List<Usuario>> getAll() async {
    var objData = ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  Future<Usuario> getById(int id) async {
    var objData = ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar usuário');
    }
  }

  Future<Object> create(Usuario usuario) async {
    var objData = ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, usuario.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        var result = jsonDecode(response.body);
        if (result['id'] != null) {
          return Usuario.fromJson(result);
        } else {
          return responseMessage.fromJson(result);
        }
      } catch (e) {
        return e;
      }
    } else {
      throw Exception('Erro ao salvar usuário');
    }
  }

  Future<Usuario> update(Usuario usuario) async {
    var objData = ConfigRequest();
    var response =
    await objData.requestUpdate(ENDPOINT, usuario.toJson(), usuario.id);

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar usuário');
    }
  }

  Future<bool> delete(int id) async {
    var objData = ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Erro ao excluir usuário');
    }
  }

  Future<Usuario> consultaUsuario(String login) async {
    var objData = ConfigRequest();
    var response =
    await objData.requestGet('$ENDPOINT?login=$login');

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Usuário não encontrado');
    }
  }

  /// Busca os dados do usuário logado através do endpoint /api/usuario/me
  Future<Usuario> me() async {
    var objData = ConfigRequest();
    var response = await objData.requestGet('$ENDPOINT/me');

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar dados do usuário logado');
    }
  }
}
