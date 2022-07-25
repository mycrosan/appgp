import 'package:GPPremium/models/qualidade.dart';
import 'package:GPPremium/screens/qualidade/ListaQualidade.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/classificacao.dart';
import '../../models/observacao.dart';
import '../../service/get_image.dart';


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



  Qualidade qualidade;

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

    qualidade = Qualidade();

    setState(() {
      qualidade = widget.qualidade;
    });
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
    var producaoApi = new ProducaoApi();

    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
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
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListaQualidade(),
                      ),
                    );

                  },
                )),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(
                    child: ElevatedButton(
                  child: Text("Atualizar"),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      // var response = await producaoApi.create(qualidade);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaQualidade(),
                        ),
                      );
                    }
                    ;
                  },
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
