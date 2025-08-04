import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:medi_connect/controllers/api.controller.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';

//Dialog que sale para agendar una cita
class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({super.key});

  @override
  AppointmentDialogState createState() => AppointmentDialogState();
}

class AppointmentDialogState extends State<AppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _patientNameController.dispose();
    super.dispose();
  }

  //Wiget para la selección de Fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime twoMonthsLater = DateTime(
      today.year,
      today.month + 2,
      today.day,
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: twoMonthsLater,
      helpText: 'SELECCIONE FECHA',
      cancelText: 'CANCELAR',
      confirmText: 'ACEPTAR',
      fieldLabelText: 'Fecha de la cita',
      errorInvalidText: 'Fecha fuera de rango',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF115181),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              secondary: const Color(0xFF115181),
              onSecondary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF115181),
              ),
            ),
            dialogTheme: DialogThemeData(
              titleTextStyle: TextStyle(
                color: const Color(0xFF115181),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //Widget para la selección de Tiempo
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'SELECCIONE HORA',
      cancelText: 'CANCELAR',
      confirmText: 'ACEPTAR',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF115181),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              secondary: const Color(0xFF115181),
              onSecondary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF115181),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  //Funcion para enviar el formulario
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor seleccione fecha y hora'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Obtener el usuario doctor del AuthCubit
      final authCubit = context.read<AuthCubit>();
      final user = authCubit.currentDoctorUser ;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo identificar al doctor'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Mostrar carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Crear el mapa con los datos requeridos
        final appointment = {
          'name': _patientNameController.text,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate!), // Formato ISO
        };

        Logger().i(appointment); // Log para debug

        // Llamar al servicio con el idDoctor y los datos
        final response = await postAppointment(user.id, appointment);

        // Cerrar loading
        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          // Cerrar diálogo y mostrar éxito
          Navigator.of(context).pop(true); // Retorna true indicando éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cita agendada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Mostrar error del backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Error al agendar la cita'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Cerrar loading y mostrar error
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Logger().e('Error al agendar cita $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Título del Dialog
              Text(
                'Agendar Nueva Cita',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              //Nombre del Paciente
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Paciente',
                  labelStyle: TextStyle(
                    color: AppColors.black,
                  ), // Color del label
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ), // Color del borde
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ), // Color del borde cuando está enfocado
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.primary, // Color del icono
                  ),
                ),
                cursorColor: AppColors.primary, // Color del cursor
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              //Botones de fecha y hora
              Row(
                children: [
                  //Boton para seleccionar fecha
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: _selectedDate == null
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () => _selectDate(context),
                      child: Text(
                        _selectedDate == null
                            ? 'Seleccionar Fecha'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  //Boton para selecionar hora
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: _selectedTime == null
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () => _selectTime(context),
                      child: Text(
                        _selectedTime == null
                            ? 'Seleccionar Hora'
                            : _selectedTime!.format(context),
                        style: TextStyle(
                          color: _selectedTime == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //Botones de Cancelar y Agendar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Boton de Cancelar
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                  ),

                  //Boton de Agendar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Agendar',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
