import 'dart:convert';
import 'package:GPPremium/models/cola.dart';
import 'package:GPPremium/models/producao.dart';
import 'config_request.dart';

class ColaApi {
  final String endpoint = "cola";

  /// Busca todas as colas
  Future<List<Cola>> getAll() async {
    final response = await ConfigRequest().requestGet(endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cola.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar colas: ${response.body}");
    }
  }

  /// Busca cola por ID
  Future<Cola> getById(int id) async {
    final response = await ConfigRequest().requestGet("$endpoint/$id");
    if (response.statusCode == 200) {
      return Cola.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erro ao buscar cola por ID: ${response.body}");
    }
  }

  /// Cria uma nova cola
  Future<Cola> create(Cola cola) async {
    final response = await ConfigRequest().requestPost(endpoint, cola.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Cola.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erro ao criar cola: ${response.body}");
    }
  }

  /// Atualiza uma cola existente
  Future<Cola> update(Cola cola) async {
    final response = await ConfigRequest().requestUpdate('$endpoint', cola.toJson(), cola.id);
    if (response.statusCode == 200) {
      return Cola.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erro ao atualizar cola: ${response.body}");
    }
  }

  /// Busca por etiqueta (pode retornar Cola ou Producao)
  Future<dynamic> getByEtiqueta(String etiqueta) async {
    final response =
        await ConfigRequest().requestGet('$endpoint/etiqueta/$etiqueta');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is Map && jsonData.containsKey('carcaca')) {
        return Producao.fromJson(jsonData);
      }

      if (jsonData is Map && jsonData.containsKey('producao')) {
        return Cola.fromJson(jsonData);
      }
      return null;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }
}
