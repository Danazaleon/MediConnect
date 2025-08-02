import 'package:logger/logger.dart';
import 'package:medi_connect/models/appointment.dart';
import 'package:medi_connect/models/doctor.dart';

List<Doctor> parseDoctors(List<dynamic> jsonList) {
  final List<Doctor> validDoctors = [];
  
  for (var doctorJson in jsonList) {
    try {
      // Verifica primero si el email NO es nulo
      if (doctorJson['email'] != null) {
        final doctor = Doctor.fromJson(doctorJson);
        validDoctors.add(doctor);
      } else {
        Logger().d('Doctor con ID ${doctorJson['id']} omitido: email es nulo');
      }
    } catch (e) {
      Logger().d('Error parseando doctor: $e');
    }
  }
  
  Logger().i("Doctors válidos encontrados: ${validDoctors.length}");
  return validDoctors;
}


List<Appointment> parseAppointments(List<dynamic> jsonList) {
  return jsonList.map<Appointment>((json) {
    return Appointment.fromJson(json as Map<String, dynamic>);
  }).toList();
}