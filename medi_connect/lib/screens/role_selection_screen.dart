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
                
                const SizedBox(height: 18),
                //Texto "Bienvenid@ a"
                const Text(
                  'Bienvenid@ a',
                  style: TextStyle(
                    fontFamily: 'Verdana',
                    fontSize: 30,
                    color: AppColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 18),
                
                // Logo MediConnect
                Image.asset(
                  'lib/assets/logo_mediconnect.png',
                  width: size.width,
                  height: size.width * 0.6,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),

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
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Verdana',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

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
                      'Como Doctor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Verdana',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón de prueba API (puedes ocultarlo en producción)
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Bordes redondeados
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ), // Más alto y rectangular
                    ),
                    onPressed: () async {
                      // Ejemplo de llamada a la API
                      // try {
                      //   Map<String, dynamic> userData = {...};
                      //   String response = await postRegister(userData);
                      //   Logger().i(response);
                      // } catch (e, stack) {
                      //   Logger().e("Error en el botón Prueba API: $e");
                      //   Logger().e(stack);
                      // }
                    },
                    child: const Text(
                      'Pruba de API',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Verdana',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
