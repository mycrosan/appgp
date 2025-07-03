class Perfil {
  final int id;
  final String descricao;
  final String authority;

  Perfil({this.id, this.descricao, this.authority});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Perfil &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
