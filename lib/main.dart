import 'package:GPPremium/screens/Resumo/ResumoCarcacas.dart';
import 'package:GPPremium/screens/antiquebra/ListaAntiquebra.dart';
import 'package:GPPremium/screens/camelback/ListaCamelback.dart';
import 'package:GPPremium/screens/carcaca/ListaCarcacas.dart';
import 'package:GPPremium/screens/cobertura/ListaCobertura.dart';
import 'package:GPPremium/screens/cola/ListaCola.dart';
import 'package:GPPremium/screens/dashboard/ajustes.dart';
import 'package:GPPremium/screens/dashboard/home.dart';
import 'package:GPPremium/screens/espessuramento/ListaEspessuramento.dart';
import 'package:GPPremium/screens/marca/ListaMarca.dart';
import 'package:GPPremium/screens/matriz/ListaMatriz.dart';
import 'package:GPPremium/screens/medida/ListaMedida.dart';
import 'package:GPPremium/screens/modelo/ListaModelo.dart';
import 'package:GPPremium/screens/pais/ListaPais.dart';
import 'package:GPPremium/screens/producao/ListaProducao.dart';
import 'package:GPPremium/screens/qualidade/ListaQualidade.dart';
import 'package:GPPremium/screens/regra/ListaRegras.dart';
import 'package:GPPremium/screens/rejeitadas/ListaRejeitadas.dart';
import 'package:GPPremium/screens/relatorio/ListaRelatorio.dart';
import 'package:GPPremium/screens/usuario/ListaUsuarios.dart';
import 'package:GPPremium/service/antiquebraapi.dart';
import 'package:GPPremium/service/camelbackapi.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/espessuramento.dart';
import 'package:GPPremium/service/marcaapi.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:GPPremium/service/qualidadeapi.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:GPPremium/service/rejeitadasapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'autenticacao/login.dart';

var SERVER_IP;

final storage = FlutterSecureStorage();

void main() {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (isProduction) {
    SERVER_IP = 'http://192.168.0.220:8080/gp/api/';
  } else {
    SERVER_IP = 'http://192.168.0.169:8080/api/';
  }
  print("Produção?${isProduction}");
  runApp(GpPremiumApp());
}

class GpPremiumApp extends StatelessWidget {
  var navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CarcacaApi>(create: (_) => CarcacaApi()),
        ChangeNotifierProvider<RejeitadasApi>(create: (_) => RejeitadasApi()),
        ChangeNotifierProvider<ProducaoApi>(create: (_) => ProducaoApi()),
        ChangeNotifierProvider<RegraApi>(create: (_) => RegraApi()),
        ChangeNotifierProvider<PaisApi>(create: (_) => PaisApi()),
        ChangeNotifierProvider<CamelbackApi>(create: (_) => CamelbackApi()),
        ChangeNotifierProvider<MedidaApi>(create: (_) => MedidaApi()),
        ChangeNotifierProvider<ModeloApi>(create: (_) => ModeloApi()),
        ChangeNotifierProvider<MarcaApi>(create: (_) => MarcaApi()),
        ChangeNotifierProvider<MatrizApi>(create: (_) => MatrizApi()),
        ChangeNotifierProvider<AntiquebraApi>(create: (_) => AntiquebraApi()),
        ChangeNotifierProvider<QualidadeApi>(create: (_) => QualidadeApi()),
        ChangeNotifierProvider<EspessuramentoApi>(
            create: (_) => EspessuramentoApi()),
      ],
      child: MaterialApp(
        routes: {
          '/espessuramento': (context) => ListaEspessuramento(),
          '/antiquebra': (context) => ListaAntiquebra(),
          '/matriz': (context) => ListaMatriz(),
          '/marca': (context) => ListaMarca(),
          '/modelo': (context) => ListaModelo(),
          '/medida': (context) => ListaMedida(),
          '/camelback': (context) => ListaCamelback(),
          '/carcacas': (context) => ListaCarcaca(),
          '/regras': (context) => ListaRegras(),
          '/producao': (context) => ListaProducao(),
          '/pais': (context) => ListaPais(),
          '/home': (_) => Home(),
          '/qualidade': (_) => ListaQualidade(),
          '/proibidas': (_) => ListaRejeitadas(),
          '/relatorio': (_) => ListaRelatorio(),
          '/usuarios': (_) => ListaUsuarios(),
          '/cobertura': (_) => ListaCobertura(),
          '/resumo': (_) => ResumoCarcacasPage(),
          '/cola': (_) => ListaColaPage(),
          '/ajustes': (_) => Ajustes(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // buttonTheme: ButtonThemeData(
          //   buttonColor: Colors.deepPurple,     //  <-- dark color
          //   textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
          // ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            primary: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          )),
          primaryColor: Colors.black,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.red,
            textTheme: ButtonTextTheme.primary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), //TextStyle
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            elevation: 10,
          ), //AppBarTheme
        ),
        home: Login(),
      ),
    );
  }
}
