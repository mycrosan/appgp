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
    this.id,
    this.numeroEtiqueta,
    this.dot,
    this.dados,
    this.modelo,
    this.medida,
    this.pais,
    this.fotos,
    this.status,
  });

  factory Carcaca.fromJson(Map<String, dynamic> json) => Carcaca(
    id: json["id"],
    numeroEtiqueta: json["numero_etiqueta"],
    dot: json["dot"],
    dados: json["dados"],
    modelo: Modelo.fromJson(json["modelo"]),
    medida: Medida.fromJson(json["medida"]),
    pais: Pais.fromJson(json["pais"]),
    fotos: json["fotos"],
    status: json["status"],
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