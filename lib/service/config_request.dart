import 'dart:convert';

import 'package:GPPremium/autenticacao/authutil.dart';
import 'package:GPPremium/models/rejeitadas.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../main.dart';
import '../models/producao.dart';
import '../models/regra.dart';

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

  Future<Response> requestQueryRejeitadas(
      String endpoint, Rejeitadas rejeitada) async {
    var jwt = await new AuthUtil().jwtOrEmpty;

    var modeloId = rejeitada.modelo != null ? rejeitada.modelo.id : null;

    var marcaId = rejeitada.modelo.marca != null ? rejeitada.modelo.marca.id : null;

    var medidaId = rejeitada.medida != null ? rejeitada.medida.id : null;

    var paisId = rejeitada.pais != null ? rejeitada.pais.id : null;

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

  Future<Response> requestQueryProducao(
      String endpoint, Producao producao) async {
    var jwt = await new AuthUtil().jwtOrEmpty;

    var modeloId = producao.carcaca.modelo != null ? producao.carcaca.modelo.id : null;
    // if(producao.carcaca.modelo.marca != null)
    var marcaId = producao.carcaca.modelo != null ? producao.carcaca.modelo.marca.id : null;

    var medidaId = producao.carcaca.medida != null ? producao.carcaca.medida.id : null;

    var paisId = producao.carcaca.pais != null ? producao.carcaca.pais.id : null;

    var numeroEtiqueta = producao.carcaca.numeroEtiqueta != null ? producao.carcaca.numeroEtiqueta : null;

    if (jwt != null) {

      var url = Uri.parse(SERVER_IP +
          endpoint +
          "/pesquisa?medidaId=${medidaId}&marcaId=${marcaId}&modeloId=${modeloId}&paisId=${paisId}&numeroEtiqueta=${numeroEtiqueta}");

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

  Future<Response> requestPesquisaRegra(
      String endpoint, Regra regra) async {
    var jwt = await new AuthUtil().jwtOrEmpty;

    var modeloId = regra.modelo != null ? regra.modelo.id : null;

    var marcaId = regra.modelo.marca != null ? regra.modelo.marca.id : null;

    var medidaId = regra.medida != null ? regra.medida.id : null;

    var paisId = regra.pais != null ? regra.pais.id : null;

    var numeroRegra = regra.id != null ? regra.id : null;

    if (jwt != null) {

      var url = Uri.parse(SERVER_IP +
          endpoint +
          "/consulta?medidaId=${medidaId}&marcaId=${marcaId}&modeloId=${modeloId}&paisId=${paisId}&numeroRegra=${numeroRegra}");

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
//Pesquisa observação por classificação
  Future<Response> requestPesquisaObservacao(
      String endpoint,  classificacaoId) async {
    var jwt = await new AuthUtil().jwtOrEmpty;

    if (jwt != null) {
      var url = Uri.parse(SERVER_IP +
          endpoint +
          "/pesquisa?tipoClassificacaoId=${classificacaoId}");
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
  Future<Response> requestQueryQualidade(
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

}
