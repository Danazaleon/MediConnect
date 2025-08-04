import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/screens/doctor_login_screen.dart';
import 'package:medi_connect/screens/patient_login_screen.dart';
import 'package:medi_connect/constants/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo MediConnect
                Image.asset(
                  'lib/assets/logo_mediconnect.png',
                  width: size.width*0.6,
                  height: size.width * 0.3,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                
                // Texto "Cómo deseas iniciar?"
                const Text(
                  '¿Cómo deseas iniciar?',
                  style: TextStyle(
                    fontFamily: 'Verdana',
                    fontSize: 25,
                    color: AppColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                
                //Logo Paciente
                Image.asset(
                  'lib/assets/logo_person.png',
                  width: size.width*0.2,
                  height: size.width * 0.2,
                  fit: BoxFit.contain,
                ),
                
                // Botón Paciente -> Lleva al Login
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), 
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ), 
                    ),
                    onPressed: () {
                      context.read<AuthCubit>().selectRole(UserRole.patient);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatientLoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Como Paciente',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Verdana',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                //Logo Doctor
                Image.asset(
                  'lib/assets/logo_doctor.png',
                  width: size.width*0.2,
                  height: size.width * 0.2,
                  fit: BoxFit.contain,
                ),

                // Botón Doctor -> Lleva al Login
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), 
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthCubit>().selectRole(UserRole.doctor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorLoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Como Doctor/a',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Verdana',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
