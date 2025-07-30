import 'dart:convert';

class Patient {
  final String name;
  final String email;
  final String phone;
  final DateTime birthdate;
  final String password;

  Patient({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.password,
  });

  // Método para convertir un JSON a un objeto Patient
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthdate: DateTime.parse(json['birthdate']),
      password: json['password'],
    );
  }

  // Método para convertir un objeto Patient a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birthdate': birthdate.toIso8601String(),
      'password': password,
    };
  }
}