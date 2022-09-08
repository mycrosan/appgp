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
    this.id,
    this.modelo,
    this.medida,
    this.pais,
    this.motivo,
    this.descricao,
  });

  factory Rejeitadas.fromJson(Map<String, dynamic> json) => Rejeitadas(
    id: json["id"],

    modelo: Modelo.fromJson(json["modelo"]),
    medida: Medida.fromJson(json["medida"]),
    pais: Pais.fromJson(json["pais"]),
    motivo: json["motivo"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "modelo": modelo.toJson(),
    "medida": medida.toJson(),
    "pais": pais.toJson(),
    "motivo": motivo,
    "status": descricao,
  };
}