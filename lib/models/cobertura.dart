import 'producao.dart';

class Cobertura {
  int id;
  String fotos;
  Producao producao;

  Cobertura({
    this.id,
    this.fotos,
    this.producao,
  });

  factory Cobertura.fromJson(Map<String, dynamic> json) {
    return Cobertura(
      id: json['id'],
      fotos: json['fotos'],
      producao: json['producao'] != null && json['producao'] is Map<String, dynamic>
          ? Producao.fromJson(json['producao'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fotos': fotos,
      'producao': producao != null ? {'id': producao.id} : null,
    };
  }
}
