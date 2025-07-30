import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../constants/url_base.dart';

//Llamada a la API para registrar un usuario
Future postRegister(Map<String, dynamic> userData) async {
  final url = Uri.http(urlBase(), 'auth/register');
  Logger().i('URL: $url');
  var body = jsonEncode(userData);
  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  var response = await http.post(url, headers: headers, body: body);

  Logger().i('Response status: ${response.statusCode}');
  //No creo que este manejo del codigo tenga que ir aca dentro, en el futuro colocare
  //que el unico return sea el reponse como tal, y dependiendo de la respuesta 
  //se decidira que se hace afuera
  if (response.statusCode == 200) {
    Logger().i('Usuario registrado correctamente: ${response.body}');
    return response.body;
  } else if (response.statusCode == 400) {
    Logger().e('Error de solicitud: ${response.body} \n Email ya registrado');
    return response.body;
  } else if (response.statusCode == 500) {
    Logger().e('Error del servidor: ${response.body}');
    throw Exception('Error del servidor: ${response.body}');
  } else {
    Logger().e('Error al registrar usuario: ${response.statusCode}');
    throw Exception('Error al registrar usuario');
  }
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