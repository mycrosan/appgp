import 'cola.dart';

class Cobertura {
  int id;
  String fotos;
  Cola cola;

  Cobertura({
    this.id,
    this.fotos,
    this.cola,
  });

  factory Cobertura.fromJson(Map<String, dynamic> json) {
    return Cobertura(
      id: json['id'],
      fotos: json['fotos'],
      cola: json['cola'] != null && json['cola'] is Map<String, dynamic>
          ? Cola.fromJson(json['cola'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fotos': fotos,
      'cola': cola != null ? {'id': cola.id} : null,
    };
  }
}
