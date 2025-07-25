import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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

  // Login para doctor
  Future<void> loginDoctor(String email, String password) async {
    emit(AuthLoading());
    try {
      // Aquí iría tu lógica de autenticación real
      await Future.delayed(const Duration(seconds: 1)); // Simulamos llamada API
      emit(DoctorAuthenticated('doctor-id-123'));
    } catch (e) {
      emit(AuthError('Error en login doctor: ${e.toString()}'));
    }
  }

  // Login para paciente
  Future<void> loginPatient(String email, String password) async {
    emit(AuthLoading());
    try {
      // Aquí iría tu lógica de autenticación real
      await Future.delayed(const Duration(seconds: 1)); // Simulamos llamada API
      emit(PatientAuthenticated('patient-id-456'));
    } catch (e) {
      emit(AuthError('Error en login paciente: ${e.toString()}'));
    }
  }

  // Método genérico de login que redirige según rol
  Future<void> login(String email, String password) async {
    if (_currentRole == UserRole.doctor) {
      await loginDoctor(email, password);
    } else if (_currentRole == UserRole.patient) {
      await loginPatient(email, password);
    } else {
      emit(AuthError('No se ha seleccionado un rol'));
    }
  }
}