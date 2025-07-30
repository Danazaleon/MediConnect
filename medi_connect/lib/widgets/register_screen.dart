import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum UserRole { paciente, doctor }

class _RegisterScreenState extends State<RegisterScreen> {
  UserRole? _role = UserRole.paciente;

  // Paciente
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Doctor
  final TextEditingController _nombreDoctorController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _calificacionController = TextEditingController();
  final TextEditingController _emailDoctorController = TextEditingController();
  final TextEditingController _telefonoDoctorController =
      TextEditingController();
  final TextEditingController _passwordDoctorController =
      TextEditingController();

  String? _especialidadSeleccionada;
  double? _calificacionSeleccionada;

  final List<String> especialidades = [
    'Medicina General',
    'Cardiología',
    'Dermatología',
    'Pediatría',
    'Neurología',
    'Ginecología',
    'Oftalmología',
    'Psiquiatría',
    'Traumatología',
  ];

  // Helper para InputDecoration con estilos personalizados
  InputDecoration customInputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.black),
      focusColor: AppColors.secondary,
      hoverColor: AppColors.secondary,
      fillColor: AppColors.background,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        titleTextStyle: const TextStyle(
          color: AppColors.secondary,
          fontFamily: 'Verdana',
          fontWeight: FontWeight.w500,
          fontSize: 25,
        ),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Imagen de personas
                Image.asset(
                  'lib/assets/register_people.png',
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),

                //Texto de pregunta
                const Text(
                  '¿Eres paciente o doctor/a?',
                  style: TextStyle(
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),

                // Toggle para seleccionar rol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedToggleSwitch<String>.size(
                      current: _role == UserRole.paciente
                          ? 'Paciente'
                          : 'Doctor',
                      height: 40,
                      values: const ['Paciente', 'Doctor'],
                      iconOpacity: 0.2,
                      indicatorSize: const Size.fromWidth(100),
                      customIconBuilder: (context, local, global) {
                        final color = Color.lerp(
                          AppColors.black,
                          AppColors.white,
                          local.animationValue,
                        );
                        return Text(
                          local.value == 'Paciente' ? 'Paciente' : 'Doctor/a',
                          style: TextStyle(
                            color: color,
                            fontFamily: 'Verdana',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        );
                      },
                      borderWidth: 5.0,
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                        indicatorColor: AppColors.secondary,
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey,
                            blurRadius: 5,
                            offset: const Offset(0, 1.5),
                          ),
                        ],
                      ),
                      selectedIconScale: 1.0,
                      onChanged: (value) => setState(() {
                        _role = value == 'Paciente'
                            ? UserRole.paciente
                            : UserRole.doctor;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //SI ES PACIENTE
                if (_role == UserRole.paciente) ...[
                  //Input Nombre
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _nombreController,
                      style: const TextStyle(color: AppColors.black),
                      decoration: customInputDecoration(label: 'Nombre'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Correo
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _emailController,
                      decoration: customInputDecoration(label: 'Email'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Telefono
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _telefonoController,
                      decoration: customInputDecoration(label: 'Teléfono'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Fecha de Nacimiento
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _fechaNacimientoController,
                      decoration: customInputDecoration(
                        label: 'Fecha de nacimiento (DD-MM-AAAA)',
                      ),
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now().subtract(
                            const Duration(days: 6570),
                          ),
                          locale: const Locale('es', ''),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors
                                      .secondary, // Color principal (header, botón OK)
                                  onPrimary: Colors
                                      .white, // Color del texto en el header
                                  surface: AppColors
                                      .background, // Fondo del calendario
                                  onSurface: AppColors
                                      .black, // Color del texto de los días
                                ),
                                dialogTheme: DialogThemeData(
                                  backgroundColor: AppColors.background,
                                ), // Fondo del diálogo
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          _fechaNacimientoController.text = DateFormat(
                            'dd-MM-yyyy',
                            'es',
                          ).format(picked);
                        }
                      },
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Contraseña
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _passwordController,
                      decoration: customInputDecoration(label: 'Contraseña'),
                      obscureText: true,
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                ]
                //SI ES DOCTOR
                else ...[
                  //Input Nombre Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _nombreDoctorController,
                      decoration: customInputDecoration(label: 'Nombre'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Especialidad
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: DropdownButtonFormField<String>(
                      value: _especialidadSeleccionada,
                      items: especialidades
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _especialidadSeleccionada = value;
                        });
                      },
                      decoration: customInputDecoration(label: 'Especialidad'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Calificación
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: DropdownButtonFormField<double>(
                      value: _calificacionSeleccionada,
                      items: [1, 2, 3, 4, 5]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.toDouble(),
                              child: Text('$e'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _calificacionSeleccionada = value;
                        });
                      },
                      decoration: customInputDecoration(
                        label: 'Calificación (1-5)',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Email Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _emailDoctorController,
                      decoration: customInputDecoration(label: 'Email'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Teléfono Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _telefonoDoctorController,
                      decoration: customInputDecoration(label: 'Teléfono'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Contraseña Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _passwordDoctorController,
                      decoration: customInputDecoration(label: 'Contraseña'),
                      obscureText: true,
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                ],
                const SizedBox(height: 30),

                //Boton de registro
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 40,
                      ),
                    ),
                    onPressed: () {
                      // Aquí puedes manejar el registro según el rol
                      if (_role == UserRole.paciente) {
                        // Lógica para registrar paciente
                      } else {
                        // Lógica para registrar doctor
                      }
                    },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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
