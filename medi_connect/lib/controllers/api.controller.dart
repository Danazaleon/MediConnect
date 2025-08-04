import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../constants/url_base.dart';

//Llamada a la API para registrar un usuario
Future postRegister(Map<String, dynamic> userData) async {
  final url = Uri.http(urlBase(), 'auth/register');
  //Logger().i('URL: $url');
  //Logger().i('userData: $userData');

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
//Map<String, dynamic> userData = {"email": "", "password": ""}
// userData debe contener el email y la contraseña del usuario
Future postLogin(Map<String, dynamic> userData) async {
  final url = Uri.http(urlBase(), 'auth/login');
  var body = jsonEncode(userData);
  var headers = {'accept': '*/*', 'Content-Type': 'application/json'};
  var response = await http.post(url, headers: headers, body: body);
  Logger().i('Response status: ${response.statusCode}');
  return response;
}

//Obtener Citas de un Doctor
// int doctorId es el ID del doctor para el cual se quieren obtener las citas
Future getAppointments(int doctorId) async {
  final url = Uri.http(urlBase(), 'doctors/$doctorId/appointments');
  Map<String, String> header = {'Accept': 'application/json'};
  try {
    var response = await http.get(url, headers: header);
    var data = jsonDecode(response.body);
    Logger().i(data);
    return data;
  } catch (e) {
    Logger().i('Error: $e');
  }
}

//Crear nueva cita para un doctor
//int doctorId es el ID del doctor para el cual se quiere crear una cita
// appointmentData debe contener los datos de la cita, como el nombre del paciente y la fecha
// Map<String, dynamic>  appointmentData = {"patientName": "Ana Gómez", "date": "2025-07-25"}
Future postAppointment(
  int doctorId,
  Map<String, dynamic> appointmentData,
) async {
  //appointmentData = {"patientName": "Ana Gómez",
  //"date": "2025-07-25"}

  final url = Uri.http(urlBase(), 'doctors/$doctorId/appointments');

  var body = jsonEncode(appointmentData);

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  var response = await http.post(url, headers: headers, body: body);

  Logger().i('Response status: ${response.statusCode}');
  return response;
}

//Obtener todos los doctores registrados
Future getDoctors() async {
  final url = Uri.http(urlBase(), 'patients/doctors');
  Map<String, String> header = {'Accept': 'application/json'};

  try {
    var response = await http.get(url, headers: header);
    var data = jsonDecode(response.body);
    Logger().i(data);
    return data;
  } catch (e) {
    Logger().i('Error: $e');
  }
}

//Obtener detalles de un doctor específico por su ID
Future getDoctorDetails(String doctorId) async {
  final url = Uri.http(urlBase(), 'patients/doctors/$doctorId');
  Map<String, String> header = {'Accept': 'application/json'};

  try {
    var response = await http.get(url, headers: header);
    var data = jsonDecode(response.body);
    Logger().i(data);
    return data;
  } catch (e) {
    Logger().i('Error: $e');
  }
}
