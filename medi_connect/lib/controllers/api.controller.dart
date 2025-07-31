import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../constants/url_base.dart';

//Llamada a la API para registrar un usuario
Future postRegister(Map<String, dynamic> userData) async {
  final url = Uri.http(urlBase(), 'auth/register');
  Logger().i('URL: $url');
  Logger().i('userData: $userData');

  var body = jsonEncode(userData);
  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  
  var response = await http.post(url, headers: headers, body: body);

  Logger().i('Response status: ${response.statusCode}');
  
  return response;
}

//Llamada a la API para iniciar sesión
Future postLogin(Map<String, dynamic> userData) async {
  final url = Uri.http(urlBase(), 'auth/login');
  var body = jsonEncode(userData);
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };
  var response = await http.post(url, headers: headers, body: body);
  Logger().i( 'Response status: ${response.statusCode}');
  return response;
  
}