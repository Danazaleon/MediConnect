import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/widgets/login_screen.dart';

//Pantalla de inicio de sesión para pacientes
class PatientLoginScreen extends StatelessWidget {
  const PatientLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      title: 'Inicia sesión como paciente',
      role: 'patient',
      authCubit: context.read<AuthCubit>(),
      imagePath: 'lib/assets/login_person.png',
    );
  }
}
