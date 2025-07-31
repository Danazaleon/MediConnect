import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:flutter/services.dart';
import 'package:medi_connect/functions/functions.dart';
import 'package:medi_connect/widgets/error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum UserRole { paciente, doctor }

class _RegisterScreenState extends State<RegisterScreen> {
  UserRole? _role = UserRole.paciente;
  
  // Paciente
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Doctor
  final TextEditingController _nameDoctorController = TextEditingController();
  final TextEditingController _emailDoctorController = TextEditingController();
  final TextEditingController _phoneDoctorController = TextEditingController();
  final TextEditingController _passwordDoctorController = TextEditingController();

  String? _specialtySelected;
  double _calificationSelected = 0.0;
  bool _hidePassword = true;

  String? _emailError;
  String? _phoneError;
  String? _passwordError;

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
  InputDecoration customInputDecoration({required String label, String? errorText}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.black),
      focusColor: AppColors.secondary,
      hoverColor: AppColors.secondary,
      fillColor: AppColors.background,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      errorText: errorText,
    );
  }

  //Helper para validar form
  void _validateForm() {
    setState(() {
      if(_role == UserRole.paciente) {
        _emailError = isValidEmail(_emailController.text) ? null : 'Correo inválido';
        _phoneError = validatePhoneNumber(_phoneController.text);
        _passwordError = isValidPassword(_passwordController.text) ? null : 'Contraseña no válida. La contraseña debe tener: \n-Al menos 8 caracteres \n-Al menos una letra mayúscula \n-Al menos un número';
      } else {
        _emailError = isValidEmail(_emailDoctorController.text) ? null : 'Correo inválido';
        _phoneError = validatePhoneNumber(_phoneDoctorController.text);
        _passwordError = isValidPassword(_passwordDoctorController.text) ? null : 'Contraseña no válida';
      }
    });
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
                // Imagen de personas
                Image.asset(
                  'lib/assets/register_people.png',
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),

                // Texto de pregunta
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

                // SI ES PACIENTE
                if (_role == UserRole.paciente) ...[
                  // Input Nombre
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: AppColors.black),
                      decoration: customInputDecoration(label: 'Nombre'),
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Correo
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _emailController,
                      decoration: customInputDecoration(label: 'Email', errorText: _emailError),
                      cursorColor: AppColors.secondary,
                      onChanged: (value) => _validateForm(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Teléfono
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _phoneController,
                      decoration: customInputDecoration(label: 'Teléfono', errorText: _phoneError),
                      onChanged: (value) => _validateForm(),
                      cursorColor: AppColors.secondary,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11), // Máximo de 10 caracteres
                        FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Fecha de Nacimiento
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _birthdateController,
                      decoration: customInputDecoration(
                        label: 'Fecha de nacimiento (AAAA-MM-DD)',
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
                          _birthdateController.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(picked);
                        }
                      },
                      cursorColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Contraseña
                  TextFormField(
                  obscureText: _hidePassword,
                  cursorColor: AppColors.secondary,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    errorText: _passwordError,
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: AppColors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:  AppColors.secondary),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondary,
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
                  onChanged: (value) => _validateForm()
                ),
                  const SizedBox(height: 25),
                ]
                
                // SI ES DOCTOR
                else ...[
                  // Input Nombre Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _nameDoctorController,
                      decoration: customInputDecoration(label: 'Nombre',errorText: _phoneError),
                      cursorColor: AppColors.secondary,
                      onChanged: (value) => _validateForm(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Email Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _emailDoctorController,
                      decoration: customInputDecoration(label: 'Email', errorText: _emailError),
                      cursorColor: AppColors.secondary,
                      onChanged: (value) => _validateForm(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Teléfono Doctor
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextField(
                      controller: _phoneDoctorController,
                      decoration: customInputDecoration(label: 'Teléfono', errorText: _phoneError),
                      cursorColor: AppColors.secondary,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11), // Máximo de 10 caracteres
                        FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos
                      ],
                      onChanged: (value) => _validateForm(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Contraseña Doctor
                  TextFormField(
                  obscureText: _hidePassword,
                  cursorColor: AppColors.secondary,
                  controller: _passwordDoctorController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    errorText: _passwordError,
                    labelStyle: TextStyle(color: AppColors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:  AppColors.secondary),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) => _validateForm(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                  const SizedBox(height: 16),

                  // Input Especialidad
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: DropdownButtonFormField<String>(
                      value: _specialtySelected,
                      items: especialidades
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _specialtySelected = value;
                          Logger().i('Especialidad: $_specialtySelected');
                        });
                      },
                      decoration: customInputDecoration(label: 'Especialidad'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Calificación
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Auto-Calificación (1-5)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Slider(
                    activeColor: AppColors.secondary, // Color del track activo
                    inactiveColor: AppColors.grey, // Color del track inactivo
                    thumbColor: AppColors.secondary, // Color del thumb
                    min: 0.0,
                    value: _calificationSelected,
                    max: 5.0,
                    divisions: 10,
                    label: _calificationSelected.toStringAsFixed(
                      1,
                    ), // Mostrar el valor actual
                    onChanged: (value) {
                      _calificationSelected =
                          value; // Actualizar el valor seleccionado
                      setState(() {});
                    },
                  ),
                  Text(
                    'Calificación seleccionada: ${_calificationSelected.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                ],

                // Botón de registro
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
                      // Llamar a la función de registro Paciente
                      if (_role == UserRole.paciente) {
                        // Validar campos para paciente
                        if (_nameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _phoneController.text.isEmpty ||
                            _birthdateController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                              showErrorDialog(context, 'Campos incompletos', 'Por favor, completa todos los campos');
                          
                          return;
                        } else {
                          Map<String, dynamic> pacienteData = {
                            "name": _nameController.text,
                            "email": _emailController.text.toLowerCase(),
                            "phone": _phoneController.text,
                            "password": _passwordController.text,
                            "type": 'patient',
                            "specialty": null,
                            "rating": null,
                            "birthdate": _birthdateController.text,
                            
                          };
                            
                          // Lógica para registrar paciente
                          context.read<AuthCubit>().registerAndLogin(
                            pacienteData,
                          );
                        }
                      }

                      // Llamar a la función de registro Doctor
                      else {
                        // Validar campos para doctor
                        if (_nameDoctorController.text.isEmpty ||
                            _emailDoctorController.text.isEmpty ||
                            _phoneDoctorController.text.isEmpty ||
                            _passwordDoctorController.text.isEmpty ||
                            _specialtySelected == null) {
                          showErrorDialog(context, 'Campos incompletos', 'Por favor, completa todos los campos');
                          
                          return;
                        } else {
                          //Registro del Doctor
                          Map<String, dynamic> doctorData = {
                            "name": _nameDoctorController.text,
                            "email": _emailDoctorController.text.toLowerCase(),
                            "phone": _phoneDoctorController.text,
                            "password": _passwordDoctorController.text,
                            "type": 'doctor',
                            "specialty": _specialtySelected,
                            "rating": _calificationSelected,
                            "birthdate": null, // No aplica para doctor
                          };
                          context.read<AuthCubit>().registerAndLogin(
                            doctorData,
                          );
                        }
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
