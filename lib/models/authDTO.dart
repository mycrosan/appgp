class AuthDTO {
  String mensagem;
  bool status;
  String token;

  AuthDTO(
      {
        this.mensagem,
        this.status,
        this.token,
       });

  AuthDTO.fromJson(Map<String, dynamic> json) {
    mensagem = json['mensagem'];
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mensagem'] = this.mensagem;
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}