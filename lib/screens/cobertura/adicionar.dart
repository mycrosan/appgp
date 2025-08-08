// import 'package:GPPremium/models/responseMessage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../models/producao.dart';
// import '../../service/producaoapi.dart';
// import 'ListaCobertura.dart';
//
//
// class AdicionarCoberturaPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return AdicionarCoberturaPageState();
//   }
// }
//
// class AdicionarCoberturaPageState extends State<AdicionarCoberturaPage> {
//
//   final _formkey = GlobalKey<FormState>();
//
//   TextEditingController textEditingControllerCobertura;
//   Producao cobertura;
//
//   void _showToast(BuildContext context) {
//     final scaffold = ScaffoldMessenger.of(context);
//     scaffold.showSnackBar(
//       SnackBar(
//         content: const Text('Added to favorite'),
//         action: SnackBarAction(
//             label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
//       ),
//     );
//   }
//
//   // @override
//   // void dispose() {
//     // Clean up the controller when the Widget is disposed
//     // textEditingControllerPneuRaspado.dispose();
//     // super.dispose();
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     textEditingControllerCobertura = TextEditingController();
//     cobertura = Producao();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cobertura'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: _construirFormulario(context),
//         ),
//       ),
//     );
//   }
//
//   Widget _construirFormulario(context) {
//     // var regraApi = new RegraApi();
//     return Form(
//       key: _formkey,
//       child: Column(
//         children: [
//           Row(children: [
//             Expanded(
//               child: TextFormField(
//                 controller: textEditingControllerCobertura,
//                 decoration: InputDecoration(
//                   labelText: "Cobertura",
//                 ),
//                 // validator: (value) =>
//                 // value.length == 0 ? 'Não pode ser nulo' : null,
//                 onChanged: (String newValue) {
//                   setState(() {
//                     cobertura.carcaca.modelo.descricao = newValue;
//                   });
//                 },
//               ),
//             ),
//             ],
//           ),
//           Padding(padding: EdgeInsets.all(10)),
//           Row(
//             children: [
//               Expanded(
//                   child: ElevatedButton(
//                 child: Text("Cancelar"),
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, "/home");
//                 },
//               )),
//               Padding(padding: EdgeInsets.all(5)),
//               Expanded(
//                   child: ElevatedButton(
//                 child: Text("Salvar"),
//                 onPressed: () async {
//                   if (_formkey.currentState.validate()) {
//
//                     var response = await ProducaoApi().create(cobertura);
//
//                     if (response is Producao && response != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ListaCobertura(),
//                         ),
//                       );
//                     } else {
//                       responseMessage value =
//                           response != null ? response : null;
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Atenção! \n" + value.message),
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
//                 },
//               )),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
