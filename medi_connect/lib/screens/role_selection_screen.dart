import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/screens/doctor_login_screen.dart';
import 'package:medi_connect/screens/patient_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu rol')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().selectRole(UserRole.doctor);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorLoginScreen()),
                );
              },
              child: const Text('Soy Doctor'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().selectRole(UserRole.patient);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatientLoginScreen()),
                );
              },
              child: const Text('Soy Paciente'),
            ),
          ],
        ),
      ),
    );
  }
}