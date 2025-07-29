import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/widgets/login_screen.dart';

class PatientLoginScreen extends StatelessWidget {
  const PatientLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      title: 'Inicia sesión como paciente',
      role: 'patient',
      authCubit: context.read<AuthCubit>(),
      onLogin: (ctx, email, password) {
        ctx.read<AuthCubit>().loginPatient(email, password);
      },
      imagePath: 'lib/assets/login_person.png',
    );
  }
}
