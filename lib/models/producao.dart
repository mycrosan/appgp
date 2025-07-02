import 'carcaca.dart';
import 'regra.dart';
import 'usuario.dart'; // Adicione essa model se existir

class Producao {
  int id;
  Carcaca carcaca;
  double medidaPneuRaspado;
  String dados;
  Regra regra;
  String fotos;
  DateTime dtCreate;
  DateTime dtUpdate;
  String uuid;
  Usuario criadoPor; // Supondo que exista uma classe Usuario

  Producao({
    this.id,
    this.carcaca,
    this.medidaPneuRaspado,
    this.dados,
    this.regra,
    this.fotos,
    this.dtCreate,
    this.dtUpdate,
    this.uuid,
    this.criadoPor,
  });

  Producao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carcaca = json['carcaca'] != null ? Carcaca.fromJson(json['carcaca']) : null;
    medidaPneuRaspado = json['medida_pneu_raspado']?.toDouble();
    dados = json['dados'];
    regra = json['regra'] != null ? Regra.fromJson(json['regra']) : null;
    fotos = json["fotos"];
    dtCreate = json['dt_create'] != null ? DateTime.parse(json['dt_create']) : null;
    dtUpdate = json['dt_update'] != null ? DateTime.parse(json['dt_update']) : null;
    uuid = json['uuid'];
    criadoPor = json['criadoPor'] != null ? Usuario.fromJson(json['criadoPor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['carcaca'] = carcaca != null ? carcaca.toJson() : null;
    data['medida_pneu_raspado'] = medidaPneuRaspado;
    data['dados'] = dados;
    data['regra'] = regra != null ? regra.toJson() : null;
    data['fotos'] = fotos;
    data['dt_create'] = dtCreate?.toIso8601String();
    data['dt_update'] = dtUpdate?.toIso8601String();
    data['uuid'] = uuid;
    data['criadoPor'] = criadoPor != null ? criadoPor.toJson() : null;
    return data;
  }
}
