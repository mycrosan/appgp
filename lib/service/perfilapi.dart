import 'dart:convert';
import 'package:GPPremium/models/usuario.dart';
import 'package:GPPremium/service/config_request.dart';

class PerfilApi {
  static const ENDPOINT = 'perfil';

  Future<List<Perfil>> getAll() async {
    var objData = ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Perfil.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar perfis');
    }
  }
}
