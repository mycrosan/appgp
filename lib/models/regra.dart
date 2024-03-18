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

  Regra({this.id,
    this.tamanhoMin,
    this.tamanhoMax,
    this.antiquebra1,
    this.antiquebra2,
    this.antiquebra3,
    this.espessuramento,
    this.tempo,
    this.matriz,
    this.medida,
    this.modelo,
    this.pais,
    this.camelback,
  });

  Regra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tamanhoMin = json['tamanho_min'];
    tamanhoMax = json['tamanho_max'];
    tempo = json['tempo'];
    matriz = json['matriz'] != null ? new Matriz.fromJson(json['matriz']) : null;
    medida = json['medida'] != null ? new Medida.fromJson(json['medida']) : null;
    modelo = json['modelo'] != null ? new Modelo.fromJson(json['modelo']) : null;
    pais = json['pais'] != null ? new Pais.fromJson(json['pais']) : null;
    camelback = json['camelback'] != null ? new Camelback.fromJson(json['camelback']) : null;
    antiquebra1 = json['antiquebra1'] != null ? new Antiquebra.fromJson(json['antiquebra1']) : null;
    antiquebra2 = json['antiquebra2'] != null ? new Antiquebra.fromJson(json['antiquebra2']) : null;
    antiquebra3 = json['antiquebra3'] != null ? new Antiquebra.fromJson(json['antiquebra3']) : null;
    espessuramento = json['espessuramento'] != null ? new Espessuramento.fromJson(json['espessuramento']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tamanho_min'] = this.tamanhoMin;
    data['tamanho_max'] = this.tamanhoMax;
    data['tempo'] = this.tempo;
    if (this.matriz != null) {
      data['matriz'] = this.matriz.toJson();
    }
    if (this.medida != null) {
      data['medida'] = this.medida.toJson();
    }
    if (this.modelo != null) {
      data['modelo'] = this.modelo.toJson();
    }
    if (this.pais != null) {
      data['pais'] = this.pais.toJson();
    }
    if (this.camelback != null) {
      data['camelback'] = this.camelback.toJson();
    }
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
