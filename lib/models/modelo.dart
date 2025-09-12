import 'marca.dart';

class Modelo {
  Modelo({
    required this.id,
    required this.descricao,
    this.marca,
  });

  int id;
  String descricao;
  Marca? marca;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Modelo &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              marca == other.marca &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ marca.hashCode ^ id.hashCode;

  factory Modelo.fromJson(Map<String, dynamic> json) => Modelo(
    id: json["id"],
    descricao: json["descricao"],
    marca: Marca.fromJson(json["marca"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
    "marca": marca?.toJson(),
  };
}