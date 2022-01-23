import 'package:GPPremium/main.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/models/responseMessageSimple.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadApi {
  Future<Object> addImage(Map<String, String> body, String filepath) async {

    String addimageUrl = SERVER_IP + 'upload';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('files', filepath));

    var response = await request.send();
    //for getting and decoding the response into json format
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);


    if (response.statusCode==200) {
      print("SUCCESS");
      return responseMessageSimple.fromJson(responseData);
    }
    else {
      print("ERROR");
    }

    // if (response.statusCode == 200) {
    //   responseMessage.fromJson(jsonDecode(response);
    //   return response;
    // } else {
    //   return response;
    // }
  }
}