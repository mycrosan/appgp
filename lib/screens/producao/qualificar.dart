import 'dart:async';
import 'dart:convert';

import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/qualidade.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../components/ImagePreview.dart';
import '../../components/OrderData.dart';
import '../../models/classificacao.dart';
import '../../models/observacao.dart';
import '../../models/producao.dart';
import '../../models/responseMessageSimple.dart';
import '../../service/Qualidadeapi.dart';
import '../../service/tipo_classificacaoapi.dart';
import '../../service/tipo_observacacaoapi.dart';
import '../../service/uploadapi.dart';

class AdicionarQualificarPage extends StatefulWidget {

  int id;
  Producao producao;

  AdicionarQualificarPage({Key key, this.producao}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdicionarQualificarPageState();
  }
}

class AdicionarQualificarPageState extends State<AdicionarQualificarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qualificar'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 70.0),
            child: _construirFormulario(context)),
      ),
    );
  }

  final _formkey = GlobalKey<FormState>();

  XFile _imageFile1;
  List _imageFileList = [];

  bool isVideo = false;

  set _imageFile(XFile value) {
    _imageFileList = value == null ? null : [value];
  }

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 10), () {
      controller.success();
    });
  }

  final RoundedLoadingButtonController _btnController1 =
  RoundedLoadingButtonController();

  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  TextEditingController textEditingControllerQualidade;
  Qualidade qualidade;

  var loading = ValueNotifier<bool>(true);

  String inputMedidaPneuRapspado;

  //Classificacão
  List<TipoClassificacao> classificacaoList = [];
  TipoClassificacao classificacaoSelected;

  //Observacação
  List<TipoObservacao> observacaoList = [];
  TipoObservacao observacaoSelected;

  List<Qualidade> qualidadeList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerQualidade = TextEditingController();
    qualidade = Qualidade();

    TipoClassificacaoApi().getAll().then((List<TipoClassificacao> value) {
      setState(() {
        classificacaoList = value;
        alfabetSortList(classificacaoList);
      });
    });


    QualidadeApi().getAll().then((List<Qualidade> value) {
      setState(() {
        qualidadeList = value;
        loading.value = false;
      });
    });

  }

  dynamic _pickImageError;

  Future getImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
      setState(() {
        _imageFileList.add(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        // await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _construirFormulario(context) {
    var qualidadeApi = new QualidadeApi();
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Text(widget.producao.carcaca.numeroEtiqueta),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Situação",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: classificacaoSelected,
            isExpanded: true,
            onChanged: (TipoClassificacao classificacao) {
              setState(() {
                classificacaoSelected = classificacao;
              });

              TipoObservacacaoApi().consulta(classificacao.id).then((Object value) {
                setState(() {
                  observacaoList = value;
                  alfabetSortList(observacaoList);
                });
              });

            },
            items: classificacaoList.map((TipoClassificacao qualificacao) {
              return DropdownMenuItem(
                value: qualificacao,
                child: Text(qualificacao.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Classificação/Condição",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: observacaoSelected,
            isExpanded: true,
            onChanged: (TipoObservacao observacao) {
              setState(() {
                observacaoSelected = observacao;
                qualidade.tipoObservacao = observacao;
              });
            },
            items: observacaoList.map((TipoObservacao observacao) {
              return DropdownMenuItem(
                value: observacao,
                child: Text(observacao.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          TextFormField(
            controller: textEditingControllerQualidade,
            decoration: InputDecoration(
              labelText: "Observação",
            ),
            // validator: (value) =>
            // value.length == 0 ? 'Não pode ser nulo' : null,
            onChanged: (String newValue) async {
              setState(() {
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Center(child: showImage(_imageFileList, "adicionar")),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: getImage,
                  tooltip: 'incrementar',
                  child: Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                  )),
              Padding(padding: EdgeInsets.all(5)),
              Expanded(
                child: RoundedLoadingButton(
                  color: Colors.black,
                  successIcon: Icons.check,
                  failedIcon: Icons.cottage,
                  child: Text('Salvar!', style: TextStyle(color: Colors.white)),
                  controller: _btnController1,
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {

                      Map<String, String> body = {
                        'title': 'qualidade',
                      };
                      responseMessageSimple imageResponse =
                      await UploadApi().addImage(body, _imageFileList);

                      print(imageResponse.content[0]);
                      qualidade.fotos = json.encode(imageResponse.content);

                      qualidade.producao = widget.producao;

                      var response = await qualidadeApi.create(qualidade);

                      _btnController1.success();

                    } else {
                      _btnController1.reset();
                    }
                  },
                ),
              ),
              // Expanded(
              //     child: ElevatedButton(
              //   child: Text("Salvar"),
              //   onPressed: () async {
              //     Map<String, String> body = {
              //       'title': 'qualidade',
              //     };
              //
              //     responseMessageSimple imageResponse =
              //         await UploadApi().addImage(body, _imageFileList);
              //
              //     print(imageResponse.content[0]);
              //     qualidade.fotos = json.encode(imageResponse.content);
              //
              //     if (_formkey.currentState.validate()) {
              //       var response = await producaoApi.create(qualidade);
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => ListaProducao(),
              //         ),
              //       );
              //     }
              //   },
              // )),
            ],
          )
        ],
      ),
    );
  }
}

Widget _exibirRegra(context) {
  //todo não funciona, montar isso reativo

  return Card(
    child: ListTile(
      title: Text(
        'Matriz: ' + context.matriz.descricao,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(
        children: [
          Text.rich(TextSpan(
              text: 'Medida: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.medida.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Marca: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.modelo.marca.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Modelo: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.modelo.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'País: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.pais.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Camelback: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.camelback.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Text.rich(TextSpan(
              text: 'COD: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.id.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Min: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.tamanhoMin.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Máx: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.tamanhoMax.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
        ],
      ),
    ),
  );

  return Container(
    child: (context.regraSelected != null)
        ? Text("ID:" +
        context.id.toString() +
        "\n"
            "Medida: " +
        context.regraSelected.medida.descricao +
        "\n"
            "Camelback: " +
        context.regraSelected.camelback.toString() +
        "\n"
            "Espessuramento: " +
        context.regraSelected.espessuramento +
        "\n"
            "Tempo: " +
        context.regraSelected.tempo +
        "\n"
            "Matriz: " +
        context.regraSelected.matriz.descricao +
        "\n"
            "Antiquebra: " +
        context.regraSelected.antiquebra1 +
        "\n"
            "Min: " +
        context.regraSelected.tamanhoMin.toString() +
        "\n"
            "Max: " +
        context.regraSelected.tamanhoMax.toString() +
        "\n")
        : null,
  );
}
