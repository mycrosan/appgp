import 'dart:convert';

import 'package:GPPremium/models/qualidade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../components/ImagePreview.dart';
import '../../components/OrderData.dart';
import '../../models/classificacao.dart';
import '../../models/observacao.dart';
import '../../models/responseMessageSimple.dart';
import '../../service/Qualidadeapi.dart';
import '../../service/tipo_classificacaoapi.dart';
import '../../service/tipo_observacacaoapi.dart';
import '../../service/uploadapi.dart';


class EditarQualidadePage extends StatefulWidget {
  int id;
  Qualidade qualidade;

  EditarQualidadePage({Key key, this.qualidade}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarQualidadePageState();
  }
}

class EditarQualidadePageState extends State<EditarQualidadePage> {
  final _formkey = GlobalKey<FormState>();

  XFile _imageFile1;
  List _imageFileList = [];

  bool isVideo = false;

  set _imageFile(XFile value) {
    _imageFileList = value == null ? null : [value];
  }

  Qualidade qualidade;

  final RoundedLoadingButtonController _btnController1 =
  RoundedLoadingButtonController();

  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  TextEditingController textEditingControllerObservacao;

  var loading = ValueNotifier<bool>(true);

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

    textEditingControllerObservacao = new TextEditingController();

    qualidade = Qualidade();

    TipoClassificacaoApi().getAll().then((List<TipoClassificacao> value) {
      setState(() {
        classificacaoList = value;
        alfabetSortList(classificacaoList);
      });
    });

    TipoObservacacaoApi().consulta(widget.qualidade.tipo_observacao.tipoClassificacao.id).then((Object value) {
      setState(() {
        observacaoList = value;
        alfabetSortList(observacaoList);
      });
    });

    setState(() {
      qualidade = widget.qualidade;
      classificacaoSelected = qualidade.tipo_observacao.tipoClassificacao;
      observacaoSelected = qualidade.tipo_observacao;
      textEditingControllerObservacao.text = qualidade.observacao;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Qualidade'),
      ),
      body: SingleChildScrollView(
        child: _construirFormulario(context),
      ),
    );
  }

  Widget _construirFormulario(context) {
    var qualidadeApi = new QualidadeApi();

    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Text(widget.producao.carcaca.numeroEtiqueta),
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
              controller: textEditingControllerObservacao,
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

                        qualidade.producao = widget.qualidade.producao;

                        var response = await qualidadeApi.create(qualidade);

                        _btnController1.success();

                      } else {
                        _btnController1.reset();
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
