import 'carcaca.dart';
import 'regra.dart';
import 'usuario.dart'; // Adicione essa model se existir

class Producao {
  int id;
  Carcaca? carcaca;
  double? medidaPneuRaspado;
  String dados;
  Regra? regra;
  String fotos;
  DateTime? dtCreate;
  DateTime? dtUpdate;
  String? uuid;
  Usuario? criadoPor; // Supondo que exista uma classe Usuario

  Producao({
    required this.id,
    this.carcaca,
    this.medidaPneuRaspado,
    required this.dados,
    this.regra,
    required this.fotos,
    this.dtCreate,
    this.dtUpdate,
    this.uuid,
    this.criadoPor,
  });

  Producao.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        dados = json['dados'] ?? '',
        fotos = json['fotos'] ?? '',
        carcaca = json['carcaca'] != null ? Carcaca.fromJson(json['carcaca']) : null,
        medidaPneuRaspado = json['medida_pneu_raspado']?.toDouble(),
        regra = json['regra'] != null ? Regra.fromJson(json['regra']) : null,
        dtCreate = json['dt_create'] != null ? DateTime.parse(json['dt_create']) : null,
        dtUpdate = json['dt_update'] != null ? DateTime.parse(json['dt_update']) : null,
        uuid = json['uuid'],
        criadoPor = json['criadoPor'] != null ? Usuario.fromJson(json['criadoPor']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['carcaca'] = carcaca?.toJson();
    data['medida_pneu_raspado'] = medidaPneuRaspado;
    data['dados'] = dados;
    data['regra'] = regra?.toJson();
    data['fotos'] = fotos;
    data['dt_create'] = dtCreate?.toIso8601String();
    data['dt_update'] = dtUpdate?.toIso8601String();
    data['uuid'] = uuid;
    data['criadoPor'] = criadoPor?.toJson();
    return data;
  }
}
