import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:GPPremium/models/authDTO.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

import 'modeloapi.dart';

class AuthApi {
  static const ROOT = 'auth';

  Future<dynamic> auth(auth) async {
    final String transactionJson = jsonEncode(auth);
    try {
      var response = await http
          .post(Uri.parse("${SERVER_IP + ROOT}"),
              headers: {
                'Content-type': 'application/json',
              },
              body: transactionJson)
          .timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        var values = response.body;
        var jsonData = jsonDecode(values);
        var jwt = AuthDTO.fromJson(jsonData).token;
        storage.write(key: "jwt", value: jwt);
        return AuthDTO.fromJson(jsonData);
      } else {
        // print('falha no login');
        // throw Exception('Falha ao tentar logar 1');
        return responseMessage.fromJson({
          "status": "false",
          "timestamp": "",
          "message": "Falha no login!",
          "error": response.body,
          "debugMessage": "debug",
          "subErrors": null
        });
      }
    } on TimeoutException catch (e) {
      return responseMessage.fromJson({
        "status": "false",
        "timestamp": "",
        "message": "O servidor não respondeu, tente novamente!",
        "error": e.message,
        "debugMessage": "debug",
        "subErrors": null
      });
    } on SocketException catch (e) {
      return responseMessage.fromJson({
        "status": "false",
        "timestamp": "",
        "message": "Falha na comunicação com o servidor",
        "error": e.message,
        "debugMessage": "debug",
        "subErrors": null
      });

      throw Exception('Falha na comunicação com o servidor!' + e.message);
    }
  }
}
