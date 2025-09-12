import 'producao.dart';

class Cola {
  int id;
  DateTime dataInicio; // Quando começou o processo de cola
  Producao? producao;

  Cola({
    required this.id,
    required this.dataInicio,
    this.producao,
  });

  factory Cola.fromJson(Map<String, dynamic> json) {
    return Cola(
      id: json['id'] ?? 0,
      dataInicio: json['dataInicio'] != null
          ? DateTime.parse(json['dataInicio'])
          : DateTime.now(),
      producao: json['producao'] != null && json['producao'] is Map<String, dynamic>
          ? Producao.fromJson(json['producao'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataInicio': dataInicio.toIso8601String(),
      'producao': producao != null ? {'id': producao!.id} : null,
    };
  }
}
