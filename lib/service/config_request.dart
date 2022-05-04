import 'dart:convert';

import 'package:GPPremium/autenticacao/authutil.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../main.dart';
import '../models/producao.dart';
import 'modeloapi.dart';

class ConfigRequest {
  Future<Response> requestGet(String endpoint) async {

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(
        Uri.parse(SERVER_IP + endpoint),
        headers: {
          'Content-type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      );
      return response;
    }
  }

  Future<Response> requestGetById(String endpoint, int id) async {

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(Uri.parse(
        SERVER_IP + endpoint + "/${id}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      );
      return response;
    }
  }

  Future<Response> requestPost(String endpoint, Map dataMap) async {

    final String bodyData = jsonEncode(dataMap);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.post(Uri.parse(SERVER_IP + endpoint),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);
      return response;
    }
  }

  Future<Response> requestUpdate(String endpoint, Map dataMap, int id) async {

    final String bodyData = jsonEncode(dataMap);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.put(Uri.parse(SERVER_IP + endpoint + "/${id}"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);
      return response;
    }
  }

  Future<Response> delete(String endpoint, int id) async {

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.delete(Uri.parse(SERVER_IP + endpoint + "/${id}"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwt'
          });
      return response;
    }
  }

  Future<Response> requestQueryRegra(String endpoint, int matrizId, int medidaId, int modeloId, int paisId, double medidaPneuRaspado) async {

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(Uri.parse(
        SERVER_IP + endpoint + "/pesquisa/${matrizId}/${medidaId}/${modeloId}/${paisId}/${medidaPneuRaspado}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      );
      return response;
    }
  }

  Future<Response> requestQueryCarcaca(String endpoint, String numeroEtiqueta) async {

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(Uri.parse(
        SERVER_IP + endpoint + "/pesquisa/${numeroEtiqueta}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      ).timeout(const Duration(seconds: 15));
      return response;
    }
  }

  Future<Response> requestQueryProducao(String endpoint, Producao producao) async {

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(Uri.parse(
          SERVER_IP + endpoint + "/pesquisa?medidaId=${producao.carcaca.medida.id}&marcaId${producao.carcaca.modelo.marca.id}&modeloId${producao.carcaca.modelo.id}&paisId${producao.carcaca.pais.id}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      );
      return response;
    }
  }
}
