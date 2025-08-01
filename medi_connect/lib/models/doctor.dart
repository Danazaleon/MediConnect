class Doctor {
  final int id;
  final String? name;
  final String email;
  final String? phone;
  final String? specialty;
  final double? rating;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.rating,
  });

  // Método para convertir un JSON a un objeto Doctor
  factory Doctor.fromJson(Map<String, dynamic> json) {
    // Verifica que id y email no sean nulos
    if (json['id'] == null) {
      throw Exception('ID no puede ser nulo');
    }
    if (json['email'] == null) {
      throw Exception('Email no puede ser nulo');
    }

    return Doctor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      specialty: json['specialty'],
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  // Método para convertir un objeto Doctor a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'email': email,
      'phone': phone,
    };
  }
}
