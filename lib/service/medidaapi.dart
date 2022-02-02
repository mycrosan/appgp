import 'dart:convert';
import 'package:GPPremium/models/medida.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:GPPremium/models/responseMessage.dart';

import 'config_request.dart';

class MedidaApi extends ChangeNotifier {

  static const ENDPOINT = 'medida';

  Future<List<Medida>> getAll() async {

    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((medida) => Medida.fromJson(medida)).toList();
    } else {
      throw Exception('Falha ao carregar medidaes');
    }
  }

  Future<Medida> getById(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Medida.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Medida> get(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      // List<dynamic> body = map['_embedded']['pneu'];
      return Medida.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(Medida medida) async {
    var map = medida.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var medida = Medida.fromJson(jsonDecode(response.body));
        if(medida.id != null){
          return medida;
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
  Future<Medida> update(Medida medida) async {
    var map = medida.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, medida.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Medida.fromJson(jsonData);
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
      throw Exception('Falha ao tentar excluir Medida');
    }
  }
}
