import 'dart:convert';
import 'package:GPPremium/models/borracha.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:GPPremium/models/responseMessage.dart';

import 'config_request.dart';

class BorrachaApi extends ChangeNotifier {

  static const ENDPOINT = 'borracha';

  Future<List<Borracha>> getAll() async {

    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((marca) => Borracha.fromJson(marca)).toList();
    } else {
      throw Exception('Falha ao carregar marcaes');
    }
  }

  Future<Borracha> getById(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Borracha.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Borracha> get(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      // List<dynamic> body = map['_embedded']['pneu'];
      return Borracha.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(Borracha marca) async {
    var map = marca.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var marca = Borracha.fromJson(jsonDecode(response.body));
        if(marca.id != null){
          return marca;
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

  Future<bool> delete(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Falha ao tentar excluir Borracha');
    }
  }
}
