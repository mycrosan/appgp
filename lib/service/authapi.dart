import 'dart:convert';
import 'package:GPPremium/models/authDTO.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_client_with_interceptor.dart';

import '../main.dart';

import 'modeloapi.dart';



class AuthApi {

  static const ROOT = 'auth';

  Future<AuthDTO> auth(auth) async {
    final http.Client client =
        HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

    final String transactionJson = jsonEncode(auth);

    var response = await client.post("${SERVER_IP+ROOT}",
        headers: {
          'Content-type': 'application/json',
        },
        body: transactionJson).timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      var values = response.body;
      var jsonData = jsonDecode(values);
      var jwt = AuthDTO.fromJson(jsonData).token;
      storage.write(key: "jwt", value: jwt);
      return AuthDTO.fromJson(jsonData);
    } else {
      throw Exception('Falha ao tentar logar');
    }
  }
}
