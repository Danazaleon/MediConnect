import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  final String title;
  final String role; // 'doctor' o 'patient'
  final AuthCubit authCubit;
  final String imagePath;

  const LoginScreen({
    super.key,
    required this.title,
    required this.role,
    required this.authCubit,
    required this.imagePath,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _ocultarPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Verdana',
          fontWeight: FontWeight.w500,
          fontSize: 25,
        ),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: widget.authCubit,
        listener: (context, state) {
          if (state is DoctorAuthenticated && widget.role == 'doctor') {
            Navigator.pushReplacementNamed(context, '/doctor-home');
          } else if (state is PatientAuthenticated && widget.role == 'patient') {
            Navigator.pushReplacementNamed(context, '/patient-home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            );
          }
          final screenWidth = MediaQuery.of(context).size.width;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                //Imagen
                Image.asset(
                  widget.imagePath,
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                
                //Campo de correo electrónico
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    labelStyle: TextStyle(color: AppColors.primary),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  cursorColor: AppColors.primary,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Campo de contraseña
                TextFormField(
                  obscureText: _ocultarPassword,
                  cursorColor: AppColors.primary,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: AppColors.primary),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarPassword ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFF001563),
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarPassword = !_ocultarPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
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
                      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                        
                        context.read<AuthCubit>().login(emailController.text, passwordController.text);
                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor ingresa tu correo y contraseña')));
                      
                      }
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
                
                //Texto de registro
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

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: const Color.fromARGB(255, 149, 4, 4),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: AppColors.black),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ),
        ],
      ),
    );
  }
}