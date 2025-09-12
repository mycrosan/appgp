
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';

import 'package:GPPremium/service/paisapi.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:rounded_loading_button/rounded_loading_button.dart'; // Removido por incompatibilidade

import '../../models/rejeitadas.dart';
import '../../service/rejeitadasapi.dart';
import 'ListaRejeitadas.dart';


class AdicionarRejeitadasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarRejeitadasPageState();
  }
}

class AdicionarRejeitadasPageState extends State<AdicionarRejeitadasPage> {
  late Rejeitadas carcaca;
  late TextEditingController textEditingControllerDescricao;
  
  @override
  void initState() {
    super.initState();
    textEditingControllerDescricao = TextEditingController();
    carcaca = Rejeitadas(
      id: 0,
      modelo: Modelo(id: 0, descricao: '', marca: null),
      medida: Medida(id: 0, descricao: ''),
      pais: Pais(id: 0, descricao: ''),
      motivo: '',
      descricao: ''
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carcaça Proibida'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 70.0),
          child: _construirFormulario(context),
        ),
      ),
    );
  }

  final _formkey = GlobalKey<FormState>();

  XFile? _imageFile1;
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // RoundedLoadingButtonController removido por incompatibilidade

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  // Campos para dropdowns
  List<Modelo> modeloList = [];
  List<Medida> medidaList = [];
  List<Pais> paisList = [];
  Modelo? modeloSelected;
  Medida? medidaSelected;
  Pais? paisSelected;
  bool isVideo = false;

  // Campos duplicados removidos

  @override
  void initState() {
    super.initState();
    // Carregamento das listas de dados
    _carregarDados();
  }
  
  void _carregarDados() async {
    try {
      final modelos = await ModeloApi().getAll();
      final medidas = await MedidaApi().getAll();
      final paises = await PaisApi().getAll();
      
      setState(() {
        modeloList = modelos;
        medidaList = medidas;
        paisList = paises;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  // XFile _imageFile;
  dynamic _pickImageError;

  Future getImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
      setState(() {
        if (pickedFile != null) {
          _imageFileList ??= [];
          _imageFileList!.add(pickedFile);
        }
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
      _retrieveDataError = response.exception?.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    final Text result = Text(_retrieveDataError ?? 'Erro desconhecido');
    _retrieveDataError = null;
    return result;
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Modelo",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: modeloSelected,
            isExpanded: true,
            onChanged: (Modelo? modelo) {
              setState(() {
                modeloSelected = modelo;
                if (modeloSelected != null) carcaca.modelo = modeloSelected!;
              });
            },
            items: modeloList.map((Modelo modelo) {
              return DropdownMenuItem(
                value: modelo,
                child: Text(modelo.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Medida",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: medidaSelected,
            isExpanded: true,
            onChanged: (Medida? medida) {
              setState(() {
                medidaSelected = medida;
                if (medidaSelected != null) carcaca.medida = medidaSelected!;
              });
            },
            items: medidaList.map((Medida medida) {
              return DropdownMenuItem(
                value: medida,
                child: Text(medida.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "País",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: paisSelected,
            isExpanded: true,
            onChanged: (Pais? pais) {
              setState(() {
                paisSelected = pais;
                if (paisSelected != null) carcaca.pais = paisSelected!;
              });
            },
            items: paisList.map((Pais pais) {
              return DropdownMenuItem(
                value: pais,
                child: Text(pais.descricao),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          TextFormField(
              controller: textEditingControllerDescricao,
              decoration: InputDecoration(
                labelText: "Motivo",
              ),
              // validator: (value) =>
              // value.length == 0 ? 'Não pode ser nulo' : null,
              onChanged: (String newValue) {
                setState(() {
                  carcaca.motivo = newValue;
                });
              },
            ),
          Padding(
            padding: EdgeInsets.all(8),
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
                child: ElevatedButton(
                  child: Text('Salvar!', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formkey.currentState?.validate() ?? false) {

                      var response = await RejeitadasApi().create(carcaca);

                      // Sucesso ao salvar

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaRejeitadas(),
                        ),
                      );
                    } else {
                      // Erro na validação
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
            ],
          )
        ],
      ),
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
