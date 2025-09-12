import 'cola.dart';

class Cobertura {
  int id;
  String fotos;
  Cola cola;

  Cobertura({
    required this.id,
    required this.fotos,
    required this.cola,
  });

  factory Cobertura.fromJson(Map<String, dynamic> json) {
    return Cobertura(
      id: json['id'] ?? 0,
      fotos: json['fotos'] ?? '',
      cola: json['cola'] != null && json['cola'] is Map<String, dynamic>
          ? Cola.fromJson(json['cola'])
          : Cola(
              id: 0, 
              dataInicio: DateTime.now(), 
              producao: null
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fotos': fotos,
      'cola': {'id': cola.id},
    };
  }
}
