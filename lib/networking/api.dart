import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './customException.dart';

import 'dart:io';

import 'package:async/async.dart';

class Api {
  // final baseUrl = 'http://192.168.0.104';
  final baseUrl = 'http://52.77.186.131:5000';
  // final baseUrl = 'http://3027267ff053.ngrok.io';

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

  Future<http.StreamedResponse> uploadProfileImage(
      String url, File _imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    var length = await _imageFile.length();

    // string to uri
    var uri = Uri.parse(baseUrl + url);

    // create multipart request
    var request = http.MultipartRequest('POST', uri);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // multipart that takes file
    var multipartFile =
        http.MultipartFile('file', stream, length, filename: _imageFile.path);
    request.headers['Authorization'] = 'Bearer ' + prefs.getString('jwt');
    // add file to multipart
    request.files.add(multipartFile);
    // send
    return await request.send();
  }

  dynamic _response(http.Response response) {
    print(response.body);
    dynamic responseJson = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseJson;
        break;
      case 400:
        throw BadRequestException(responseJson['message']);
        break;
      case 401:
        throw UnauthorisedException(responseJson['message']);
        break;
      case 403:
        throw ForbiddenException(responseJson['message']);
        break;
      case 404:
        throw DataNotFoundException(responseJson['message']);
        break;
      case 500:
        throw InternalServerException(responseJson['message']);
        break;
      default:
        throw FetchDataException(
            'Error occured while communicating with server with status code: ${response.statusCode}');
    }
  }
}
