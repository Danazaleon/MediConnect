import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:medi_connect/controllers/api.controller.dart';
import 'package:medi_connect/models/user.dart';

part 'role_state.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  UserRole _currentRole = UserRole.none;

  // Selección de rol
  void selectRole(UserRole role) {
    _currentRole = role;
    emit(AuthRoleSelected(role));
  }

  // Login
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      Map<String, dynamic> userData = {'email': email, 'password': password};
      final response = await postLogin(userData);
      Logger().i('Llegamos aca ${response.statusCode}');
      Logger().i('Response data: ${response.body}');

      if (response.statusCode == 200) {

        Map<String, dynamic> parsedJson = json.decode(response.body);

        User user = User.fromJson(parsedJson['user']);

        Logger().i(user.type);

        // Verificar si el tipo de usuario coincide con el rol seleccionado
        if ((_currentRole == UserRole.doctor && user.type == 'doctor') ||
            (_currentRole == UserRole.patient && user.type == 'patient')) {
          Logger().i(user.type);
          // Emitir el estado de autenticación correspondiente

          if (_currentRole == UserRole.doctor) {
            emit(DoctorAuthenticated(user.id));
            
          } else if (_currentRole == UserRole.patient) {
            emit(PatientAuthenticated(user.id));
          }
        } else {
          // Si el tipo de usuario no coincide con el rol seleccionado
          emit(
            AuthError(
              'No tienes permiso para acceder como ${_currentRole == UserRole.doctor ? 'doctor' : 'paciente'}.',
            ),
          );
        }
      } else if (response.statusCode == 401) {
        emit(AuthError('Credenciales inválidas'));
      } else {
        emit(AuthError('Error en la autenticación: ${response.errorMessage}'));
      }
    } catch (e) {
      emit(AuthError('Error en la conexión: ${e.toString()}'));
    }
  }
}
