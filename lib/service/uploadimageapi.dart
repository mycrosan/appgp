import 'dart:convert';
import 'package:GPPremium/models/producao.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'config_request.dart';

class UploadImageApi extends ChangeNotifier {
  static const ENDPOINT = 'upload';

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
    http.Response response = await http.get(Uri.parse(url),
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
    var producaoMap = producao.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, producaoMap);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Producao.fromJson(jsonData);
      print('Aqui');
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
      throw Exception('Falha ao tentar excluir carcaça');
    }
  }
}
