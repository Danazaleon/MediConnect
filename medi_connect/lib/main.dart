import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/screens/doctor_home_screen.dart';
import 'package:medi_connect/screens/doctor_login_screen.dart';
import 'package:medi_connect/screens/patient_home_screen.dart';
import 'package:medi_connect/screens/patient_login_screen.dart';
import 'package:medi_connect/screens/role_selection_screen.dart';
import 'package:medi_connect/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediConnect',
        initialRoute: '/',
        routes: {
          '/': (context) => const RoleSelectionScreen(),
          '/doctor-login': (context) => const DoctorLoginScreen(),
          '/patient-login': (context) => const PatientLoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/doctor-home': (context) => const DoctorHomeScreen(),
          '/patient-home': (context) => PatientHomeScreen(),
        },
      ),
    );
  }
}
