import 'dart:async';
import 'dart:io';

import 'package:GPPremium/main.dart';
import 'package:GPPremium/models/responseMessageSimple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadApi {

  Future<Object> addImage(Map<String, String> body, List imagesList) async {

    String addimageUrl = SERVER_IP + 'upload';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl));
    request.fields.addAll(body);
    request.headers.addAll(headers);

    for(final i in imagesList) {
      request.files.add(
          await http.MultipartFile.fromPath('files', i.path));
    }
    try {
      var response = await request.send().timeout(const Duration(seconds: 60));
      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);

      final responseData = json.decode(responsed.body);

      if (response.statusCode==200) {
        return responseMessageSimple.fromJson(responseData);
      }
      else {
        throw Exception("Erro no upload: ${response.statusCode}");
      }

    } on TimeoutException catch (_) {
      throw Exception("Timeout: Não retornou nenhuma imagem");
    } on SocketException catch (_) {
      throw Exception("Erro de conexão");
    }
  }
}