import 'dart:convert';
import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/service/config_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:GPPremium/models/responseMessage.dart';

class CarcacaApi extends ChangeNotifier {
  static const ENDPOINT = 'carcaca';

  Future<List<Carcaca>> getAll() async {
    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((carcacas) => Carcaca.fromJson(carcacas)).toList();
    } else {
      throw Exception('Falha ao carregar carcaças');
    }
  }

  Future<Carcaca> getById(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Carcaca.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(Carcaca carcaca) async {
    var map = carcaca.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var value = Carcaca.fromJson(jsonDecode(response.body));
        if (value.id != null) {
          return value;
        } else {
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        return responseMessage.fromJson(jsonDecode(response.body));
      }
    } else {
      throw Exception('Falha ao tentar salvar');
    }
  }

  Future<Object> update(Carcaca carcaca) async {
    var map = carcaca.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, carcaca.id);

    if (response.statusCode == 200) {
      try {
        var value = Carcaca.fromJson(jsonDecode(response.body));
        if (value.id != null) {
          return value;
        } else {
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        return responseMessage.fromJson(jsonDecode(response.body));
      }
    } else {
      throw Exception('Falha ao tentar atualizar');
    }
  }

  Future<Object> delete(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      // var mapValues= jsonData as Map;
      notifyListeners();
      return true;
    } else {
      // return responseMessage.fromJson(jsonDecode(response.body));
      throw Exception('Falha ao tentar excluir carcaça');
    }
  }

  Future<Object> consultaCarcaca(numeroEtiqueta) async {
    var objData = new ConfigRequest();
    var response = await objData.requestQueryCarcaca(ENDPOINT, numeroEtiqueta);

    if (response.statusCode == 200) {
      try {
        var value = Carcaca.fromJson(jsonDecode(response.body));
        if (value.id != null) {
          return value;
        } else {
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        return responseMessage.fromJson(jsonDecode(response.body));
      }
    } else {
      throw Exception('Falha ao carregar Carcaça');
    }
  }
  Future<Map<String, int>> getResumo() async {
    var objData = ConfigRequest();
    var response = await objData.requestGet('resumo/$ENDPOINT');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, int>.from(data.map((key, value) => MapEntry(key, value as int)));
    } else {
      throw Exception('Falha ao carregar resumo de carcaças');
    }
  }

}
