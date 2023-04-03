import 'dart:convert';
import 'package:GPPremium/components/OrderData.dart';
import 'package:GPPremium/models/matriz.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:GPPremium/models/responseMessage.dart';

import 'config_request.dart';

class MatrizApi extends ChangeNotifier {

  static const ENDPOINT = 'matriz';

  Future<List<Matriz>> getAll() async {

    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      var values = body.map((pais) => Matriz.fromJson(pais)).toList();
      alfabetSortList(values);
      return values;
    } else {
      throw Exception('Falha ao carregar paises');
    }
  }

  Future<Matriz> getById(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Matriz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Matriz> get(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      // List<dynamic> body = map['_embedded']['pneu'];
      return Matriz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(Matriz pais) async {
    var map = pais.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var pais = Matriz.fromJson(jsonDecode(response.body));
        if(pais.id != null){
          return pais;
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
  Future<Matriz> update(Matriz matriz) async {
    var map = matriz.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, matriz.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Matriz.fromJson(jsonData);
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
      throw Exception('Falha ao tentar excluir Matriz');
    }
  }
}
