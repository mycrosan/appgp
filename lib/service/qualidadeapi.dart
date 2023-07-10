import 'dart:convert';
import 'package:GPPremium/models/qualidade.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:GPPremium/models/responseMessage.dart';


import '../models/producao.dart';
import 'config_request.dart';

class QualidadeApi extends ChangeNotifier {
  static const ENDPOINT = 'qualidade';

  Future<List<Qualidade>> getAll() async {
    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      return body.map((qualidades) => Qualidade.fromJson(qualidades)).toList();
    } else {
      throw Exception('Falha ao carregar producões');
    }
  }

  Future<Qualidade> getById(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Qualidade.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Qualidade> get(String url) async {
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
      return Qualidade.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar um post');
    }
  }

  Future<Qualidade> create(Qualidade qualidade) async {
    var qualidadeMap = qualidade.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, qualidadeMap);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Qualidade.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar');
    }
  }

  Future<Qualidade> update(Qualidade qualidade) async {
    var map = qualidade.toJson();

    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, qualidade.id);

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      // var mapValues= jsonData as Map;
      return Qualidade.fromJson(jsonData);
      print('Aqui');
    } else {
      throw Exception('Falha ao tentar salvar qualidade');
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

  //  Future<Object> consultaQualidade(numeroEtiqueta) async {
  //   var objData = new ConfigRequest();
  //   var response = await objData.requestQueryCarcaca(ENDPOINT, numeroEtiqueta);
  //
  //   if (response.statusCode == 200) {
  //     try {
  //       var value = Qualidade.fromJson(jsonDecode(response.body));
  //       if (value.id != null) {
  //         return value;
  //       } else {
  //         return responseMessage.fromJson(jsonDecode(response.body));
  //       }
  //     } catch (e) {
  //       return responseMessage.fromJson(jsonDecode(response.body));
  //     }
  //   } else {
  //     throw Exception('Falha ao carregar Qualidade');
  //   }
  // }

  Future<Object>consultaQualidade(numeroEtiqueta) async {

    var objData = new ConfigRequest();
    var response = await objData.requestQueryQualidade(ENDPOINT, numeroEtiqueta);

    if (response.statusCode == 200) {
      try {
        var value = Qualidade.fromJson(jsonDecode(response.body));
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
