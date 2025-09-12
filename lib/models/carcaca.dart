import 'package:flutter/cupertino.dart';

import 'pais.dart';
import 'medida.dart';
import 'modelo.dart';

class Carcaca {

  int id;
  String numeroEtiqueta;
  String dot;
  String dados;
  Modelo modelo;
  Medida medida;
  Pais pais;
  String fotos;
  String status;

  Carcaca({
    required this.id,
    required this.numeroEtiqueta,
    required this.dot,
    required this.dados,
    required this.modelo,
    required this.medida,
    required this.pais,
    required this.fotos,
    required this.status,
  });

  factory Carcaca.fromJson(Map<String, dynamic> json) => Carcaca(
    id: json["id"] ?? 0,
    numeroEtiqueta: json["numero_etiqueta"] ?? '',
    dot: json["dot"] ?? '',
    dados: json["dados"] ?? '',
    modelo: json["modelo"] != null ? Modelo.fromJson(json["modelo"]) : Modelo(id: 0, descricao: ''),
    medida: json["medida"] != null ? Medida.fromJson(json["medida"]) : Medida(id: 0, descricao: ''),
    pais: json["pais"] != null ? Pais.fromJson(json["pais"]) : Pais(id: 0, descricao: ''),
    fotos: json["fotos"] ?? '',
    status: json["status"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "numero_etiqueta": numeroEtiqueta,
    "dot": dot,
    "dados": dados,
    "modelo": modelo.toJson(),
    "medida": medida.toJson(),
    "pais": pais.toJson(),
    "fotos": fotos,
    "status": status,
  };
}