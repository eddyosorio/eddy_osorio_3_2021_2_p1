import 'dart:convert';

import 'package:eddy_osorio_3_2021_2_p1/models/data_anime.dart';
import 'package:http/http.dart' as http;
import 'package:eddy_osorio_3_2021_2_p1/models/response';

import 'constans.dart';

class ApiHelper{
   
  static Future<Response> getProcedures() async {

    var url = Uri.parse('${Constans.apiUrl}/api/v1/');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<DataAnime> list = [];    
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(DataAnime.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: list);
  }
}