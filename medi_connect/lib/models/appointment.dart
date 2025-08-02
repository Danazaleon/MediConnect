class Appointment {
  final int id;
  final int doctorId;
  final String? patientName;
  final DateTime date;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientName,
    required this.date,
  });

  // Método para crear una instancia de Appointment desde un JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctorId'],
      patientName: json['patientName'] ?? 'No tiene nombre', // Asignar valor por defecto
      date: DateTime.parse(json['date']),
    );
  }

  // Método para convertir una instancia de Appointment a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientName': patientName,
      'date': date.toIso8601String(),
    };
  }
}