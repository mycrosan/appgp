import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:GPPremium/models/cobertura.dart';
import 'package:GPPremium/service/config_request.dart'; // Classe de requisição HTTP
import 'package:GPPremium/models/responseMessage.dart';

import '../models/producao.dart'; // Modelo para resposta genérica

class CoberturaApi extends ChangeNotifier {
  static const ENDPOINT =
      'cobertura'; // Definir o endpoint específico para Cobertura

  // Obter todas as coberturas
  Future<List<Cobertura>> getAll() async {
    var objData = new ConfigRequest();
    var response = await objData.requestGet(ENDPOINT);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      List<dynamic> body = map;
      return body.map((cobertura) => Cobertura.fromJson(cobertura)).toList();
    } else {
      throw Exception('Falha ao carregar coberturas');
    }
  }

  // Obter cobertura por ID
  Future<Cobertura> getById(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.requestGetById(ENDPOINT, id);

    if (response.statusCode == 200) {
      return Cobertura.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar a cobertura');
    }
  }

// Adicione dentro da classe CoberturaApi
  Future<Map<String, dynamic>> getByEtiqueta(String etiqueta) async {
    var objData = ConfigRequest();
    var response = await objData.requestGet('$ENDPOINT/etiqueta/$etiqueta');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map<String, dynamic>) {
        return jsonData;
      }
      return {};
    } else if (response.statusCode == 404) {
      return {};
    } else {
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }


  // Criar uma nova cobertura
  Future<Object> create(Cobertura cobertura) async {
    print('📦 Enviando cobertura: ${jsonEncode(cobertura.toJson())}');

    var map = cobertura.toJson();
    var objData = ConfigRequest();
    var response = await objData.requestPost(ENDPOINT, map);

    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);

        // Se tiver um ID válido, retorna a Cobertura
        if (json['id'] != null) {
          return Cobertura.fromJson(json);
        } else {
          // Caso contrário, possivelmente erro do tipo responseMessage
          return responseMessage.fromJson(json);
        }
      } catch (e) {
        print("Erro ao decodificar resposta da cobertura: $e");
        return responseMessage(
            debugMessage: "Erro ao interpretar resposta do servidor.");
      }
    } else {
      print("Erro HTTP ${response.statusCode}: ${response.body}");
      try {
        return responseMessage.fromJson(jsonDecode(response.body));
      } catch (_) {
        throw Exception(
            'Falha ao tentar salvar a cobertura (${response.statusCode})');
      }
    }
  }

  // Atualizar uma cobertura existente
  Future<Object> update(Cobertura cobertura) async {
    var map = cobertura.toJson();
    var objData = new ConfigRequest();
    var response = await objData.requestUpdate(ENDPOINT, map, cobertura.id);

    if (response.statusCode == 200) {
      try {
        var value = Cobertura.fromJson(jsonDecode(response.body));
        if (value.id != null) {
          return value;
        } else {
          return responseMessage.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        return responseMessage.fromJson(jsonDecode(response.body));
      }
    } else {
      throw Exception('Falha ao tentar atualizar a cobertura');
    }
  }

  // Excluir uma cobertura
  Future<Object> delete(int id) async {
    var objData = new ConfigRequest();
    var response = await objData.delete(ENDPOINT, id);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Falha ao tentar excluir a cobertura');
    }
  }
}
