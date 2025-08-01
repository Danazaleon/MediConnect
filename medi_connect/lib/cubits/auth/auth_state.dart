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
  final User user;

  DoctorAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Estado cuando el paciente se autentica correctamente
class PatientAuthenticated extends AuthState {
  final User user;

  PatientAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Estado de éxito genérico
class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess(this.message);
}

/// Estado de error genérico
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}