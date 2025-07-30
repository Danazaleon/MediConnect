

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String type; // 'doctor' o 'patient'
  final String? specialty;
  final double? rating; 
  final DateTime? birthdate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.type,
    required this.specialty,
    required this.rating,
    required this.birthdate,
  });

  // Método para convertir un JSON a un objeto User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      type: json['type'],
      specialty: json['specialty'],
      rating: (json['rating'] as num?)?.toDouble(),
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null, 
    );
  }

  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'type': type,
      'specialty': specialty,
      'rating': rating,
      'birthdate': birthdate?.toIso8601String(),
    };
  }
}