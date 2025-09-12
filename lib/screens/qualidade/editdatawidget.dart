import 'dart:convert';

import 'package:GPPremium/models/qualidade.dart';
import 'package:GPPremium/screens/qualidade/ListaQualidade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart'; // Removido por incompatibilidade
import '../../models/classificacao.dart';
import '../../models/observacao.dart';
import '../../service/Qualidadeapi.dart';
import '../../service/get_image.dart';
import '../../service/tipo_classificacaoapi.dart';
import '../../service/tipo_observacacaoapi.dart';



class EditarQualidadePage extends StatefulWidget {
  final int id;
  final Qualidade? qualidade;

  const EditarQualidadePage({Key? key, required this.id, this.qualidade}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarQualidadePageState();
  }
}

class EditarQualidadePageState extends State<EditarQualidadePage> {
  final _formkey = GlobalKey<FormState>();

  XFile? _imageFile1;
  List<XFile>? _imageFileList = [];

  bool isVideo = false;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  late Qualidade qualidade;

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  late TextEditingController textEditingControllerObservacao;

  var loading = ValueNotifier<bool>(true);

  //Classificacão
  List<TipoClassificacao> classificacaoList = [];
  TipoClassificacao? classificacaoSelected;

  //Observacação
  List<TipoObservacao> observacaoList = [];
  TipoObservacao? observacaoSelected;

  List<Qualidade> qualidadeList = [];

  @override
  void initState() {
    super.initState();

    textEditingControllerObservacao = new TextEditingController();

    qualidade = widget.qualidade ?? Qualidade(
      id: 0,
      producao: Producao(id: 0, dados: '', fotos: ''),
      observacao: '',
      fotos: '',
      tipo_observacao: TipoObservacao(id: 0, descricao: '', tipoClassificacao: TipoClassificacao(id: 0, descricao: '')),
    );

    TipoClassificacaoApi().getAll().then((List<TipoClassificacao> value) {
      setState(() {
        classificacaoList = value;
      });
    });

    TipoObservacacaoApi().consulta(widget.qualidade.tipo_observacao.tipoClassificacao.id).then((Object value) {
      setState(() {
        observacaoList = value;
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
                  observacaoSelected = null;
                });

                TipoObservacacaoApi().consulta(classificacao.id).then((Object value) {
                  setState(() {
                    observacaoList = value;
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
                  qualidade.tipo_observacao = observacao;
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
                  qualidade.observacao = newValue;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            // Center(child: showImage(_imageFileList, "adicionar")),
            // Container(
            //   padding: EdgeInsets.all(20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       FloatingActionButton(
            //         backgroundColor: Colors.blue,
            //         onPressed: getImage,
            //         tooltip: 'incrementar',
            //         child: Icon(Icons.camera_alt),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              child: FutureBuilder(
                  future: new ImageService().showImage(qualidade.fotos, "qualidade"),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return snapshot.data[index];
                          },
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(5),
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
                    child: Text('Atualizar!', style: TextStyle(color: Colors.white)),
                    controller: _btnController1,
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {

                        var response = await qualidadeApi.update(qualidade);

                        _btnController1.success();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaQualidade(),
                          ),
                        );

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
