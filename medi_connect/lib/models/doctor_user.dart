class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String email;
  final String phone;
  final String password;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.email,
    required this.phone,
    required this.password,
  });

  // Método para convertir un JSON a un objeto Doctor
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      specialty: json['specialty'],
      rating: (json['rating'] as num).toDouble(),
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  // Método para convertir un objeto Doctor a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}