part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Estado de carga
class AuthLoading extends AuthState {}

/// Estado cuando se selecciona un rol
class AuthRoleSelected extends AuthState {
  final UserRole role;

  AuthRoleSelected(this.role);

  @override
  List<Object?> get props => [role];
}

/// Estado cuando el doctor se autentica correctamente
class DoctorAuthenticated extends AuthState {
  final int doctorId;

  DoctorAuthenticated(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

/// Estado cuando el paciente se autentica correctamente
class PatientAuthenticated extends AuthState {
  final int patientId;

  PatientAuthenticated(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Estado de error genérico
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}