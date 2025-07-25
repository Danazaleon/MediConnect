import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';

class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login Doctor')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is DoctorAuthenticated) {
            // Navegar a pantalla principal de doctor
            Navigator.pushReplacementNamed(context, '/doctor-home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().loginDoctor(
                          emailController.text,
                          passwordController.text,
                        );
                  },
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}