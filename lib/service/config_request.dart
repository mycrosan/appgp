import 'dart:convert';

import 'package:GPPremium/autenticacao/authutil.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

import '../main.dart';
import 'modeloapi.dart';

class ConfigRequest {
  Future<Response> requestGet(String endpoint) async {
    final http.Client client =
        HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await http.get(
        SERVER_IP + endpoint,
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
    final http.Client client =
        HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await client.get(
        SERVER_IP + endpoint + "/${id}",
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
    final http.Client client =
        HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    final String bodyData = jsonEncode(dataMap);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await client.post(SERVER_IP + endpoint,
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

    final http.Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    final String bodyData = jsonEncode(dataMap);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await client.put(SERVER_IP + endpoint + "/${id}",
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);
      return response;
    }
  }

  Future<Response> requestQueryRegra(String endpoint, int matrizId, int medidaId, int modeloId, int paisId, double medidaPneuRaspado) async {

    final http.Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await client.get(
        SERVER_IP + endpoint + "/pesquisa/${matrizId}/${medidaId}/${modeloId}/${paisId}/${medidaPneuRaspado}",
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

    final http.Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await client.get(
        SERVER_IP + endpoint + "/pesquisa/${numeroEtiqueta}",
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
      );
      return response;
    }
  }

  Future<Response> delete(String endpoint, int id) async {
    final http.Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    var jwt = await new AuthUtil().jwtOrEmpty;
    if (jwt != null) {
      http.Response response = await client.delete(SERVER_IP + endpoint + "/${id}",
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwt'
          });
      return response;
    }
  }
}
