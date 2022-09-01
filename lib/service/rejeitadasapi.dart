import 'dart:convert';
import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/service/config_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:GPPremium/models/responseMessage.dart';

import '../models/rejeitadas.dart';

class RejeitadasApi extends ChangeNotifier {
  static const ENDPOINT = 'carcacarejeitada';

  Future<List<Rejeitadas>> getAll() async {
    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((carcacas) => Rejeitadas.fromJson(carcacas)).toList();
    } else {
      throw Exception('Falha ao carregar carcaças');
    }
  }

  Future<Rejeitadas> getById(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Rejeitadas.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Rejeitadas> create(Rejeitadas carcaca) async {
    var map = carcaca.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Rejeitadas.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar carcaça');
    }
  }

  Future<Rejeitadas> update(Rejeitadas carcaca) async {
    var map = carcaca.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, carcaca.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Rejeitadas.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar carcaça');
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

  Future<Object> consultaRejeitadas(numeroEtiqueta) async {
    var objData = new ConfigRequest();
    var response = await objData.requestQueryRejeitadas(ENDPOINT, numeroEtiqueta);

    if (response.statusCode == 200) {
      try {
        var value = Rejeitadas.fromJson(jsonDecode(response.body));
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


}
