import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart';

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
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Doctor
  final TextEditingController _nombreDoctorController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _calificacionController = TextEditingController();
  final TextEditingController _emailDoctorController = TextEditingController();
  final TextEditingController _telefonoDoctorController = TextEditingController();
  final TextEditingController _passwordDoctorController = TextEditingController();

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
                  width: screenWidth * 0.7, // 35% del ancho de pantalla
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
                      current: _role == UserRole.paciente ? 'Paciente' : 'Doctor',
                      height: 40,
                      values: const ['Paciente', 'Doctor'],
                      iconOpacity: 0.2,
                      indicatorSize: const Size.fromWidth(100),
                      customIconBuilder: (context, local, global) {
                        final color = Color.lerp(AppColors.black, AppColors.white, local.animationValue);
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
                          )
                        ]
                      ),
                      selectedIconScale: 1.0,
                      onChanged: (value) => setState(() {
                        _role = value == 'Paciente' ? UserRole.paciente : UserRole.doctor;
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
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Correo
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Telefono
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Fecha de Nacimiento
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _fechaNacimientoController,
                      decoration: const InputDecoration(labelText: 'Fecha de nacimiento (YYYY-MM-DD)'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _fechaNacimientoController.text = picked.toIso8601String().split('T').first;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  //Input Contraseña
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
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
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Especialidad
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: DropdownButtonFormField<String>(
                      value: _especialidadSeleccionada,
                      items: especialidades
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _especialidadSeleccionada = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Especialidad'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Calificación
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: DropdownButtonFormField<double>(
                      value: _calificacionSeleccionada,
                      items: [1, 2, 3, 4, 5]
                          .map((e) => DropdownMenuItem(
                                value: e.toDouble(),
                                child: Text('$e'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _calificacionSeleccionada = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Calificación (1-5)'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Email Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _emailDoctorController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Teléfono Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _telefonoDoctorController,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Input Contraseña Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _passwordDoctorController,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
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
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
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