import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:medi_connect/widgets/error_dialog.dart';

// Pantalla de inicio de sesión para doctores y pacientes
// Permite a los usuarios ingresar su correo electrónico y contraseña para autenticarse en la aplicación
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
  bool _hidePassword = true;

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
            showErrorDialog( context,"Error al ingresar",state.message);
            
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
                  obscureText: _hidePassword,
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
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                        color:AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
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
                        
                        context.read<AuthCubit>().login(emailController.text.toLowerCase(), passwordController.text);
                        
                      } else {
                        showErrorDialog( context,"Faltan Campos","Por favor ingresa tu correo y contraseña");
                        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor ingresa tu correo y contraseña')));
                      
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

}