// import 'package:GPPremium/models/carcaca.dart';
// import 'package:GPPremium/models/matriz.dart';
// import 'package:GPPremium/models/medida.dart';
// import 'package:GPPremium/models/modelo.dart';
// import 'package:GPPremium/models/pais.dart';
// import 'package:GPPremium/models/producao.dart';
// import 'package:GPPremium/models/regra.dart';
// import 'package:GPPremium/models/responseMessage.dart';
// import 'package:GPPremium/service/carcacaapi.dart';
// import 'package:GPPremium/service/matrizapi.dart';
// import 'package:GPPremium/service/producaoapi.dart';
// import 'package:GPPremium/service/regraapi.dart';
// import 'package:extended_masked_text/extended_masked_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../service/get_image.dart';
// import 'ListaProducao.dart';
//
// class EditarProducaoPage extends StatefulWidget {
//   int id;
//   Producao producao;
//
//   EditarProducaoPage({Key key, this.producao}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return EditarProducaoPageState();
//   }
// }
//
// class EditarProducaoPageState extends State<EditarProducaoPage> {
//   final _formkey = GlobalKey<FormState>();
//
//   TextEditingController textEditingControllerCarcaca;
//   MaskedTextController textEditingControllerPneuRaspado;
//   TextEditingController textEditingControllerDados;
//   TextEditingController textEditingControllerRegra;
//
//   Medida medidaCarcaca;
//   Modelo modeloCarcaca;
//   Pais paisCarcaca;
//   bool mostrarCarcacaSelecionada = true;
//
//   TextEditingController camelBackASerUsado;
//   TextEditingController antiquebra1;
//   TextEditingController antiquebra2;
//   TextEditingController antiquebra3;
//   TextEditingController espessuraemnto;
//   TextEditingController tempo;
//
//   Producao producao;
//
//   bool idRegra = false;
//
//   String inputMedidaPneuRapspado;
//
//   //Pneu
//   List<Carcaca> carcacaList = [];
//   Carcaca carcacaSelected;
//
//   //Regra
//   List<Matriz> matrizList = [];
//   Matriz matrizSelected;
//
//   //Regra
//   List<Regra> regraList = [];
//   Regra regraSelected;
//
//   @override
//   void initState() {
//     super.initState();
//     textEditingControllerCarcaca = MaskedTextController(mask: '000000');
//     textEditingControllerPneuRaspado = MaskedTextController(mask: '0.000');
//     textEditingControllerDados = TextEditingController();
//     textEditingControllerRegra = TextEditingController();
//     producao = Producao();
//
//     camelBackASerUsado = TextEditingController();
//     antiquebra1 = TextEditingController();
//     antiquebra2 = TextEditingController();
//     antiquebra3 = TextEditingController();
//     espessuraemnto = TextEditingController();
//     tempo = TextEditingController();
//
//     // CarcacaApi().getAll().then((List<Carcaca> value) {
//     //   setState(() {
//     //     carcacaList = value;
//     //   });
//     // });
//
//     MatrizApi().getAll().then((List<Matriz> value) {
//       setState(() {
//         matrizList = value;
//       });
//     });
//
//     // RegraApi().getAll().then((List<Regra> value) {
//     //   setState(() {
//     //     regraList = value;
//     //   });
//     // });
//
//     setState(() {
//       producao = widget.producao;
//       textEditingControllerPneuRaspado.text =
//           widget.producao.medidaPneuRaspado.toString();
//       textEditingControllerCarcaca.text =
//           widget.producao.carcaca.numeroEtiqueta.toString();
//       medidaCarcaca = widget.producao.carcaca.medida;
//       modeloCarcaca = widget.producao.carcaca.modelo;
//       paisCarcaca = widget.producao.carcaca.pais;
//       matrizSelected = widget.producao.regra.matriz;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Editar Produção'),
//       ),
//       body: SingleChildScrollView(
//         child: _construirFormulario(context),
//       ),
//     );
//   }
//
//   Widget _construirFormulario(context) {
//     var producaoApi = new ProducaoApi();
//
//     return Form(
//       key: _formkey,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: textEditingControllerCarcaca,
//               decoration: InputDecoration(
//                 labelText: "Carcaça",
//               ),
//               validator: (value) =>
//                   value.length == 0 ? 'Não pode ser nulo' : null,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               onChanged: (String newValue) async {
//                 setState(() {
//                   producao.carcaca = null;
//                   medidaCarcaca = null;
//                   modeloCarcaca = null;
//                   paisCarcaca = null;
//                   textEditingControllerPneuRaspado.clear();
//                   mostrarCarcacaSelecionada = false;
//                 });
//                 if (newValue.length >= 6) {
//                   var response = await CarcacaApi().consultaCarcaca(newValue);
//                   if (response is Carcaca && response != null) {
//                     setState(() {
//                       producao.carcaca = response;
//                       medidaCarcaca = response.medida;
//                       modeloCarcaca = response.modelo;
//                       paisCarcaca = response.pais;
//                       mostrarCarcacaSelecionada = true;
//                     });
//                   } else {
//                     responseMessage value = response;
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text(value.message),
//                           content: Text(value.debugMessage),
//                           actions: [
//                             TextButton(
//                               child: Text("OK"),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 }
//                 // setState(() {
//                 //   inputMedidaPneuRapspado = newValue;
//                 // });
//               },
//             ),
//             Container(
//               child: mostrarCarcacaSelecionada
//                   ? Card(
//                       child: ListTile(
//                         title: Text('Etiqueta: ' +
//                             producao.carcaca.numeroEtiqueta.toString()),
//                         subtitle: Text('Medida: ' +
//                             medidaCarcaca.descricao +
//                             ' Modelo: ' +
//                             modeloCarcaca.descricao +
//                             ' Pais: ' +
//                             paisCarcaca.descricao),
//                       ),
//                     )
//                   : Text(''),
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//             ),
//             DropdownButtonFormField(
//               decoration: InputDecoration(
//                 labelText: "Matriz",
//               ),
//               validator: (value) => value == null ? 'Não pode ser nulo' : null,
//               value: matrizSelected,
//               isExpanded: true,
//               onChanged: (Matriz matriz) {
//                 // var regra = regraList.firstWhere((regra) => regra.id == matriz.id);
//                 setState(() {
//                   matrizSelected = matriz;
//                 });
//               },
//               items: matrizList.map((Matriz matriz) {
//                 return DropdownMenuItem(
//                   value: matriz,
//                   child: Text(matriz.descricao),
//                 );
//               }).toList(),
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//             ),
//             TextFormField(
//               controller: textEditingControllerPneuRaspado,
//               decoration: InputDecoration(
//                 labelText: "Medida pneu raspado",
//               ),
//               validator: (value) =>
//                   value.length == 0 ? 'Não pode ser nulo' : null,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               onChanged: (String newValue) async {
//                 print(newValue);
//                 if (newValue.length >= 5) {
//                   if (_formkey.currentState.validate()) {
//                     regraSelected = null;
//                     var response = await RegraApi().consultaRegra(
//                         matrizSelected,
//                         medidaCarcaca,
//                         modeloCarcaca,
//                         paisCarcaca,
//                         double.parse(newValue));
//
//                     if (response is Regra && response != null) {
//                       setState(() {
//                         regraSelected = response;
//                         producao.medidaPneuRaspado = double.parse(newValue);
//                         producao.regra = regraSelected;
//                       });
//                     } else {
//                       responseMessage value = response;
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text(value.message),
//                             content: Text(value.debugMessage),
//                             actions: [
//                               TextButton(
//                                 child: Text("OK"),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                   }
//                 }
//                 setState(() {
//                   inputMedidaPneuRapspado = newValue;
//                 });
//               },
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//             ),
//             Container(
//               child: (regraSelected != null)
//                   ? Text("ID:" +
//                   regraSelected.id.toString() +
//                   "\n"
//                       "Medida: " +
//                   regraSelected.medida.descricao +
//                   "\n"
//                       "Camelback: " +
//                   regraSelected.camelback.descricao +
//                   "\n"
//                       "Espessuramento: " +
//                   (regraSelected.espessuramento != null
//                       ? regraSelected.espessuramento.descricao
//                       : 'NI') +
//                   "\n"
//                       "Tempo: " +
//                   regraSelected.tempo +
//                   "\n"
//                       "Matriz: " +
//                   regraSelected.matriz.descricao +
//                   "\n"
//                       "Antiquebra1: " +
//                   regraSelected.antiquebra1.descricao +
//                   "\n"
//                       "Antiquebra2: " +
//                   (regraSelected.antiquebra2 != null
//                       ? regraSelected.antiquebra2.descricao
//                       : 'NI') +
//                   "\n"
//                       "Antiquebra3: " +
//                   (regraSelected.antiquebra3 != null
//                       ? regraSelected.antiquebra3.descricao
//                       : 'NI') +
//                   "\n"
//                       "Min: " +
//                   regraSelected.tamanhoMin.toString() +
//                   "\n"
//                       "Max: " +
//                   regraSelected.tamanhoMax.toString() +
//                   "\n")
//                   : null,
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//             ),
//             Container(
//               child: FutureBuilder(
//                   future: new ImageService().showImage(producao.fotos, "producao"),
//                   builder: (context, AsyncSnapshot snapshot) {
//                     if (snapshot.hasData) {
//                       return Container(
//                         height: 200.0,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: snapshot.data.length,
//                           itemBuilder: (BuildContext ctxt, int index) {
//                             return snapshot.data[index];
//                           },
//                         ),
//                       );
//                     } else {
//                       return CircularProgressIndicator();
//                     }
//                   }),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                     child: ElevatedButton(
//                   child: Text("Cancelar"),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ListaProducao(),
//                       ),
//                     );
//
//                   },
//                 )),
//                 Padding(padding: EdgeInsets.all(5)),
//                 Expanded(
//                     child: ElevatedButton(
//                   child: Text("Atualizar"),
//                   onPressed: () async {
//                     if (_formkey.currentState.validate()) {
//                       var response = await producaoApi.create(producao);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ListaProducao(),
//                         ),
//                       );
//                     }
//                     ;
//                   },
//                 )),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
