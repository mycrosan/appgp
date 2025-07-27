import 'dart:convert';
import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'config_request.dart';

class ProducaoApi extends ChangeNotifier {
  static const ENDPOINT = 'producao';

  Future<List<Producao>> getAll() async {
    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      return body.map((producaos) => Producao.fromJson(producaos)).toList();
    } else {
      throw Exception('Falha ao carregar producões');
    }
  }

  Future<Producao> getById(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Producao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Producao> get(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJBUEkgR1AiLCJzdWIiOiIxIiwiaWF0IjoxNjI2Mzk0ODg1LCJleHAiOjE2MjY0ODEyODV9.arQYCzPe_dXXDe9vZaV4g5T6YBF12yfG3av8phYRt-A'
      },
    );

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      return Producao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(Producao producao) async {
    var map = producao.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var value = Producao.fromJson(jsonDecode(response.body));
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

  Future<Producao> update(Producao producao) async {
    var map = producao.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, producao.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Producao.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar carcaça');
    }
  }

  Future<bool> delete(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Falha ao tentar excluir carcaça');
    }
  }

  Future<Object> consultaProducao(Producao producao) async {

    var objData = new ConfigRequest();
    var response = await objData.requestQueryProducao(ENDPOINT, producao);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      return body.map((producaos) => Producao.fromJson(producaos)).toList();
    } else {
      throw Exception('Falha ao carregar producões');
    }
  }
  Future<Map<String, int>> getResumo() async {
    var objData = ConfigRequest();
    var response = await objData.requestGet('resumo/$ENDPOINT');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, int>.from(
        data.map((key, value) => MapEntry(key, value as int)),
      );
    } else {
      throw Exception('Falha ao carregar resumo de produção');
    }
  }
}
