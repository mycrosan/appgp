import 'producao.dart';

class Cola {
  int id;
  DateTime dataInicio; // Quando começou o processo de cola
  Producao producao;

  Cola({
    this.id,
    this.dataInicio,
    this.producao,
  });

  factory Cola.fromJson(Map<String, dynamic> json) {
    return Cola(
      id: json['id'],
      dataInicio: json['dataInicio'] != null
          ? DateTime.parse(json['dataInicio'])
          : null,
      producao: json['producao'] != null && json['producao'] is Map<String, dynamic>
          ? Producao.fromJson(json['producao'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataInicio': dataInicio != null ? dataInicio.toIso8601String() : null,
      'producao': producao != null ? {'id': producao.id} : null,
    };
  }
}
