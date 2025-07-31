bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

String? validatePhoneNumber(String value) {
  if (value.isEmpty) {
    return 'Por favor, ingrese un número de teléfono';
  } else if (value.length < 11) { // Mínimo de 11 caracteres
    return 'El número de teléfono debe tener 11 caracteres';
  } else if (value.length > 11) { // Máximo de 11 caracteres
    return 'El número de teléfono no puede tener más de 11 caracteres';
  }
  return null; // Sin errores
}

bool isValidPassword(String password) {
  // Longitud mínima de 8 caracteres
  if (password.length < 8) return false;

  // Verificar si contiene al menos una letra mayúscula
  if (!RegExp(r'[A-Z]').hasMatch(password)) return false;

  // Verificar si contiene al menos un número
  if (!RegExp(r'[0-9]').hasMatch(password)) return false;

  return true; // La contraseña es válida
}