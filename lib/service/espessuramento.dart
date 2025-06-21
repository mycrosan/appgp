import 'dart:convert';
import 'package:GPPremium/models/espessuramento.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'config_request.dart';

class EspessuramentoApi extends ChangeNotifier {

  static const ENDPOINT = 'espessuramento';

  Future<List<Espessuramento>> getAll() async {

    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((espessuramento) => Espessuramento.fromJson(espessuramento)).toList();
    } else {
      throw Exception('Falha ao carregar Espessuramento');
    }
  }

  Future<Espessuramento> getById(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Espessuramento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um espessuramento');
    }
  }

  Future<Espessuramento> get(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      // List<dynamic> body = map['_embedded']['pneu'];
      return Espessuramento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um espessuramento');
    }
  }

  Future<Object> create(Espessuramento espessuramento) async {
    var map = espessuramento.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var value = Espessuramento.fromJson(jsonDecode(response.body));
        if(value.id != null){
          return value;
        }else{
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      }catch (e){
        return e;
      }
    } else {
      throw Exception('Falha ao tentar salvar');
    }
  }
  Future<Espessuramento> update(Espessuramento espessuramento) async {
    var map = espessuramento.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, espessuramento.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Espessuramento.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar Regra');
    }
  }

  Future<bool> delete(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Falha ao tentar excluir Espessuramento');
    }
  }
}
