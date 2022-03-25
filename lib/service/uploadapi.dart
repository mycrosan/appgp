import 'dart:async';
import 'dart:io';

import 'package:GPPremium/main.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/models/responseMessageSimple.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
      var response = await request.send().timeout(const Duration(seconds: 30));
      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);

      // try {
      //   final request = await client.get(...);
      //   final response = await request.close()
      //       .timeout(const Duration(seconds: 2));
      // // rest of the code
      // ...
      // } on TimeoutException catch (_) {
      // // A timeout occurred.
      // } on SocketException catch (_) {
      // // Other exception
      // }
      final responseData = json.decode(responsed.body);


      if (response.statusCode==200) {
        print("SUCCESS");
        return responseMessageSimple.fromJson(responseData);
      }
      else {
        print("ERROR");
      }

    } on TimeoutException catch (_) {
      print("Não retornou nenhuma imagem");
    } on SocketException catch (_) {

    }



    // if (response.statusCode == 200) {
    //   responseMessage.fromJson(jsonDecode(response);
    //   return response;
    // } else {
    //   return response;
    // }
  }
}