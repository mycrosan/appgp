import 'package:flutter/cupertino.dart';

import 'pais.dart';
import 'medida.dart';
import 'modelo.dart';

class Rejeitadas {

  int id;
  Modelo modelo;
  Medida medida;
  Pais pais;
  String motivo;
  String descricao;

  Rejeitadas({
    required this.id,
    required this.modelo,
    required this.medida,
    required this.pais,
    required this.motivo,
    required this.descricao,
  });

  factory Rejeitadas.fromJson(Map<String, dynamic> json) => Rejeitadas(
    id: json["id"] ?? 0,
    modelo: json["modelo"] != null ? Modelo.fromJson(json["modelo"]) : Modelo(id: 0, descricao: ''),
    medida: json["medida"] != null ? Medida.fromJson(json["medida"]) : Medida(id: 0, descricao: ''),
    pais: json["pais"] != null ? Pais.fromJson(json["pais"]) : Pais(id: 0, descricao: ''),
    motivo: json["motivo"] ?? '',
    descricao: json["descricao"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "modelo": modelo.toJson(),
    "medida": medida.toJson(),
    "pais": pais.toJson(),
    "motivo": motivo,
    "descricao": descricao,
  };
}