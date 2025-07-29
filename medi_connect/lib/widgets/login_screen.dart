import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  final String title;
  final String role; // 'doctor' o 'patient'
  final void Function(BuildContext, String, String) onLogin;
  final AuthCubit authCubit;
  final String imagePath;

  const LoginScreen({
    super.key,
    required this.title,
    required this.role,
    required this.onLogin,
    required this.authCubit,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(title),
        titleTextStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Verdana',
          fontWeight: FontWeight.w500,
          fontSize: 25,
        ),
      backgroundColor: AppColors.background),
      
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, state) {
          if (state is DoctorAuthenticated && role == 'doctor') {
            Navigator.pushReplacementNamed(context, '/doctor-home');
          } else if (state is PatientAuthenticated && role == 'patient') {
            Navigator.pushReplacementNamed(context, '/patient-home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final screenWidth = MediaQuery.of(context).size.width;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  width: screenWidth * 0.7, // 35% del ancho de pantalla
                  height: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),
                //Correo electronico
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    fillColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 30),

                //Contraseña
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña',
                  focusColor: AppColors.primary,
                  prefixIconColor: AppColors.primary,
                  suffixIconColor: AppColors.primary,
                  hoverColor: AppColors.primary,
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                // Botón de inicio de sesión
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      onLogin(
                        context,
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Verdana',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Texto de registro con hipervínculo
                RichText(
                  text: TextSpan(
                    text: '¿No tienes cuenta? ',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Verdana',
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Regístrate aquí',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
