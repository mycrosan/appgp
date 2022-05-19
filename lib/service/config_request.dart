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
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      ).timeout(Duration(seconds: 60));
      return response;
    }
  }

  Future<Response> requestGetById(String endpoint, int id) async {
    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(
        Uri.parse(SERVER_IP + endpoint + "/${id}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      ).timeout(Duration(seconds: 60));
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
      http.Response response =
          await http.put(Uri.parse(SERVER_IP + endpoint + "/${id}"),
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
      http.Response response = await http
          .delete(Uri.parse(SERVER_IP + endpoint + "/${id}"), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt'
      }).timeout(Duration(seconds: 60));
      return response;
    }
  }

  Future<Response> requestQueryRegra(String endpoint, int matrizId,
      int medidaId, int modeloId, int paisId, double medidaPneuRaspado) async {
    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(
        Uri.parse(SERVER_IP +
            endpoint +
            "/pesquisa/${matrizId}/${medidaId}/${modeloId}/${paisId}/${medidaPneuRaspado}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      ).timeout(Duration(seconds: 60));
      return response;
    }
  }

  Future<Response> requestQueryCarcaca(
      String endpoint, String numeroEtiqueta) async {
    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(
        Uri.parse(SERVER_IP + endpoint + "/pesquisa/${numeroEtiqueta}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      ).timeout(const Duration(seconds: 60));
      return response;
    }
  }

  Future<Response> requestQueryProducao(
      String endpoint, Producao producao) async {
    var jwt = await new AuthUtil().jwtOrEmpty;

    var modeloId =
        producao.carcaca.modelo.id != null ? producao.carcaca.modelo.id : null;
    var marcaId = producao.carcaca.modelo.marca.id != null
        ? producao.carcaca.modelo.marca.id
        : null;
    var medidaId =
        producao.carcaca.medida != null ? producao.carcaca.medida.id : null;
    var paisId = producao.carcaca.pais != null ? producao.carcaca.pais.id : null;

    if (jwt != null) {
      var url = Uri.parse(SERVER_IP +
          endpoint +
          "/pesquisa?medidaId=${medidaId}&marcaId=${marcaId}&modeloId=${modeloId}&paisId=${paisId}");



      http.Response response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      ).timeout(Duration(seconds: 60));
      return response;
    }
  }
}
