import 'dart:convert';
import 'package:GPPremium/models/classificacao.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'config_request.dart';

class TipoClassificacaoApi extends ChangeNotifier {

  static const ENDPOINT = 'tipoclassificacao';

  Future<List<TipoClassificacao>> getAll() async {

    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      // print(body[0]['_links']['self']);
      return body.map((values) => TipoClassificacao.fromJson(values)).toList();
    } else {
      throw Exception('Falha ao carregar paises');
    }
  }

  Future<TipoClassificacao> getById(int id) async {

    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return TipoClassificacao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<TipoClassificacao> get(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      // List<dynamic> body = map['_embedded']['pneu'];
      return TipoClassificacao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Object> create(TipoClassificacao tipoClassificacao) async {
    var map = tipoClassificacao.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 200) {
      try {
        var pais = TipoClassificacao.fromJson(jsonDecode(response.body));
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
  Future<TipoClassificacao> update(TipoClassificacao pais) async {
    var map = pais.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, pais.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return TipoClassificacao.fromJson(jsonData);
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
      throw Exception('Falha ao tentar excluir TipoClassificacao');
    }
  }
}
