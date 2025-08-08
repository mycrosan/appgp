// import 'package:GPPremium/models/marca.dart';
// import 'package:GPPremium/service/marcaapi.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../models/producao.dart';
// import '../../service/producaoapi.dart';
//
// class DetalhesCoberturaPage extends StatefulWidget {
//
//   int id;
//   DetalhesCoberturaPage({Key key, this.id}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return DetalhesCoberturaPageState();
//   }
// }
//
// class DetalhesCoberturaPageState extends State<DetalhesCoberturaPage> {
//   @override
//   Widget build(BuildContext context) {
//     var modeloApi = new ProducaoApi();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detalhe Cobertura'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: FutureBuilder(
//           future: modeloApi.getById(widget.id),
//           builder: (context, AsyncSnapshot<Producao> snapshot) {
//             if (snapshot.hasData) {
//               return RichText(
//                 text: TextSpan(
//                   style: DefaultTextStyle.of(context).style,
//                   children: <TextSpan>[
//                     TextSpan(text: 'ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                     TextSpan(text: snapshot.data.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                     TextSpan(text: '\n\n'),
//                     TextSpan(text: 'ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                     // TextSpan(text: snapshot.data.descricao.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                     TextSpan(text: '\n\n'),
//                   ],
//                 ),
//               );
//             } else {
//               return CircularProgressIndicator();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
