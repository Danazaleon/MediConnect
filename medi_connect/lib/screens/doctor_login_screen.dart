import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/widgets/login_screen.dart';


class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      title: 'Inicia sesión como doctor/a',
      role: 'doctor',
      authCubit: context.read<AuthCubit>(),
      imagePath: 'lib/assets/login_doctor.png'
    );
  }
}