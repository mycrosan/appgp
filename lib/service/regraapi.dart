import 'dart:convert';
import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'config_request.dart';

class RegraApi extends ChangeNotifier {
  static const ENDPOINT = 'regra';

  Future<List<Regra>> getAll() async {
    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((regra) => Regra.fromJson(regra)).toList();
    } else {
      throw Exception('Falha ao carregar regra');
    }
  }

  Future<Regra> getById(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Regra.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Regra> get(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      // List<dynamic> body = map['_embedded']['pneu'];
      return Regra.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(Regra regra) async {
    var map = regra.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var regra = Regra.fromJson(jsonDecode(response.body));
        if (regra.id != null) {
          return regra;
        } else {
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        return e;
      }
    } else {
      throw Exception('Falha ao tentar salvar');
    }
  }

  Future<Regra> update(Regra regra) async {
    var map = regra.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, regra.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Regra.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar Regra');
    }
  }

  Future<Object> consultaRegra(
      matriz, medida, modelo, pais, double medidaPneuRapstado) async {
    var objData = new ConfigRequest();
    var response = await objData.requestQueryRegra(
        ENDPOINT, matriz.id, medida.id, modelo.id, pais.id, medidaPneuRapstado);

    if (response.statusCode == 200) {
      try {
        var regra = Regra.fromJson(jsonDecode(response.body));
        if (regra.id != null) {
          return regra;
        } else {
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        return e;
      }
    } else {
      throw Exception('Falha ao carregar regra');
    }
  }

  Future<bool> delete(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      // var mapValues= jsonData as Map;
      notifyListeners();
      return true;
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar excluir carcaça');
    }
  }
}
