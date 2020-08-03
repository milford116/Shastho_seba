import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './customException.dart';

class Api {
  final baseUrl = 'http://52.77.186.131:5000';
// final baseUrl = 'http://c6a8eb34.ngrok.io';

  Future<dynamic> get(String url, bool authorization) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (authorization) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      headers.addAll({
        'Authorization': 'Bearer ' + prefs.getString('jwt'),
      });
    }
    return _response(await http.get(
      baseUrl + url,
      headers: headers,
    ));
  }

  Future<dynamic> post(String url, bool authorization, var object) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (authorization) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      headers.addAll({
        'Authorization': 'Bearer ' + prefs.getString('jwt'),
      });
    }
    return _response(await http.post(
      baseUrl + url,
      headers: headers,
      body: jsonEncode(object),
    ));
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print(response.body);
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 400:
        throw BadRequestException(response.body);
        break;
      case 401:
        throw UnauthorisedException(response.body);
        break;
      case 403:
        throw ForbiddenException(response.body);
        break;
      case 404:
        throw DataNotFoundException(response.body);
        break;
      case 500:
        throw InternalServerException(response.body);
        break;
      default:
        throw FetchDataException(
            "Error occured while communicating with server with status code: ${response.statusCode}");
    }
  }
}