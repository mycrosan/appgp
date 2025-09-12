import 'package:GPPremium/models/antiquebra.dart';
import 'package:GPPremium/models/espessuramento.dart';
import 'camelback.dart';
import 'pais.dart';
import 'matriz.dart';
import 'medida.dart';
import 'modelo.dart';

class Regra {
  int id;
  double tamanhoMin;
  double tamanhoMax;
  String tempo;
  Matriz matriz;
  Medida medida;
  Modelo modelo;
  Pais pais;
  Camelback camelback;
  Antiquebra antiquebra1;
  Antiquebra antiquebra2;
  Antiquebra antiquebra3;
  Espessuramento espessuramento;

  Regra({
    required this.id,
    required this.tamanhoMin,
    required this.tamanhoMax,
    required this.antiquebra1,
    required this.antiquebra2,
    required this.antiquebra3,
    required this.espessuramento,
    required this.tempo,
    required this.matriz,
    required this.medida,
    required this.modelo,
    required this.pais,
    required this.camelback,
  });

  Regra.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        tamanhoMin = (json['tamanhoMin'] ?? 0.0).toDouble(),
        tamanhoMax = (json['tamanhoMax'] ?? 0.0).toDouble(),
        tempo = json['tempo'] ?? '',
        matriz = json['matriz'] != null ? Matriz.fromJson(json['matriz']) : Matriz(id: 0, descricao: ''),
        medida = json['medida'] != null ? Medida.fromJson(json['medida']) : Medida(id: 0, descricao: ''),
        modelo = json['modelo'] != null ? Modelo.fromJson(json['modelo']) : Modelo(id: 0, descricao: ''),
        pais = json['pais'] != null ? Pais.fromJson(json['pais']) : Pais(id: 0, descricao: ''),
        camelback = json['camelback'] != null ? Camelback.fromJson(json['camelback']) : Camelback(id: 0, descricao: ''),
        antiquebra1 = json['antiquebra1'] != null ? Antiquebra.fromJson(json['antiquebra1']) : Antiquebra(id: 0, descricao: ''),
        antiquebra2 = json['antiquebra2'] != null ? Antiquebra.fromJson(json['antiquebra2']) : Antiquebra(id: 0, descricao: ''),
        antiquebra3 = json['antiquebra3'] != null ? Antiquebra.fromJson(json['antiquebra3']) : Antiquebra(id: 0, descricao: ''),
        espessuramento = json['espessuramento'] != null ? Espessuramento.fromJson(json['espessuramento']) : Espessuramento(id: 0, descricao: '');

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tamanho_min'] = this.tamanhoMin;
    data['tamanho_max'] = this.tamanhoMax;
    data['tempo'] = this.tempo;
    data['matriz'] = this.matriz.toJson();
      data['medida'] = this.medida.toJson();
      data['modelo'] = this.modelo.toJson();
      data['pais'] = this.pais.toJson();
      data['camelback'] = this.camelback.toJson();
      if (this.antiquebra1 != null) {
      data['antiquebra1'] = this.antiquebra1.toJson();
    }
    if (this.antiquebra2 != null) {
      data['antiquebra2'] = this.antiquebra2.toJson();
    }
    if (this.antiquebra3 != null) {
      data['antiquebra3'] = this.antiquebra3.toJson();
    }
    if (this.espessuramento != null) {
      data['espessuramento'] = this.espessuramento.toJson();
    }
    return data;
  }
}
