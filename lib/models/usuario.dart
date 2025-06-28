class Usuario {
  int id;
  String nome;
  String login;
  String senha;
  List<Perfil> perfil;
  bool status;

  Usuario(
      {this.id,
        this.nome,
        this.login,
        this.senha,
        this.perfil,
        this.status,
       });

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    login = json['login'];
    senha = json['senha'];
    status = json['status'];
    if (json['perfil'] != null) {
      perfil = new List<Perfil>();
      json['perfil'].forEach((v) {
        perfil.add(new Perfil.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['login'] = this.login;
    data['senha'] = this.senha;
    data['status'] = this.status;
    data['perfil'] = this.perfil.map((v) => v.toJson()).toList();
      return data;
  }
}

class Perfil {
  int id;
  String descricao;
  String authority;

  Perfil({this.id, this.descricao, this.authority});

  Perfil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    authority = json['authority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['authority'] = this.authority;
    return data;
  }
}