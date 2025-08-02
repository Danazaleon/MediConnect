import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:medi_connect/controllers/api.controller.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/functions/parses.dart';
import 'package:medi_connect/models/appointment.dart';
import 'package:medi_connect/screens/add_appointment_screen.dart';
import 'package:medi_connect/widgets/appointment_item.dart';

//Pantalla de inicio del doctor
class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreen();
}

class _DoctorHomeScreen extends State<DoctorHomeScreen> {
  //Listas de citas
  List<Appointment> appointmentsFounds = [];
  List<Appointment> allAppointments = [];

  //Variables
  bool isLoading = true;
  String? errorMessage;
  bool _isFilterActive = false;
  DateTimeRange? _activeDateRange;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>(); // Accede al AuthCubit
    final user = authCubit.currentDoctorUser; // Obtén el usuario actual

    if (user != null) {
      fetchAppointments(
        user.id,
      ); // Llama a fetchAppointments con el ID del usuario
    } else {
      setState(() {
        errorMessage = 'Usuario no encontrado';
      });
    }
  }

  //Llamada a la API para obtener las citas
  void fetchAppointments(int userId) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      var json = await getAppointments(userId); // Usa el ID del usuario
      Logger().i(json);
      
      setState(() {
        allAppointments = json != null ? parseAppointments(json) : []; // Guarda todas las citas
        appointmentsFounds = List.from(allAppointments); // Inicializa appointmentsFounds con todas las citas
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar citas';
        isLoading = false;
      });
      debugPrint('Error cargando citas: $e');
    }
  }
  //Rango de Fechas para escoger
  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 7)),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary, // Color principal
              onPrimary: Colors.white, // Texto sobre el color principal
              surface: AppColors.background, // Fondo del calendario
              onSurface: Colors.black, // Texto del calendario
              secondary: Color(0x80115181),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _filterAppointments(picked.start, picked.end);
    }
  }

  //Función para mostrar el diálogo de agregar cita
  Future<void> _showAddAppointmentDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AppointmentDialog(),
    );

    // Si el diálogo retorna true, refresca las citas
    if (result == true) {
      _refreshAppointments(); // Llama a la función que refresca las citas
    }
  }

  // Función para refrescar las citas
  void _refreshAppointments() {
    final user = context.read<AuthCubit>().currentDoctorUser;
    if (user != null) {
      fetchAppointments(user.id);
    }
  }

  // Función para filtrar citas
  void _filterAppointments(DateTime startDate, DateTime endDate) {
    setState(() {
      _isFilterActive = true;
      _activeDateRange = DateTimeRange(start: startDate, end: endDate);
      appointmentsFounds = allAppointments.where((appointment) {
        final extendedEndDate = endDate.add(const Duration(days: 1));
        return appointment.date.isAfter(startDate) &&
            appointment.date.isBefore(extendedEndDate);
      }).toList();
    });
  }

  // Función para quitar el filtro
  void _clearFilter() {
  setState(() {
    _isFilterActive = false;
    _activeDateRange = null;
    appointmentsFounds = List.from(allAppointments); // Restaura las citas desde la lista maestra
    
    // Opcional: Si necesitas forzar un refresh desde la API:
    final user = context.read<AuthCubit>().currentDoctorUser ;
    if (user != null) fetchAppointments(user.id); // Vuelve a cargar todo desde la API
  });
}

  //Widget para mostrar el indicador de filtro
  Widget _buildFilterIndicator() {
  if (!_isFilterActive || _activeDateRange == null) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Card(
      color: AppColors.background, // Fondo sutil
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Filtro: ${DateFormat('dd/MM/yyyy').format(_activeDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_activeDateRange!.end)}",
              style: TextStyle(color: AppColors.primary),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 20),
              onPressed: _clearFilter, // Llama a la función mejorada
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    ),
  );
}
  
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>(); // Accede al AuthCubit
    final user = authCubit.currentDoctorUser; // Obtén el usuario actual

    return Scaffold(
      //Barra de Navegación
      appBar: AppBar(
        title: const Text(
          'MediConnect',
          style: TextStyle(
            color: Colors.white, // Texto blanco
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          //Bontón de Cierre de Sesión
          IconButton(
            icon: const Icon(Icons.logout),
            color: AppColors.white,
            onPressed: () {
              // Cerrar sesión
              Navigator.pushReplacementNamed(context, '/');
              //Revisar que si este haciendo el cierre de sesión adecuadamente
            },
          ),
          SizedBox(width: 20),
        ],
      ),

      //Manu Lateral
      drawer: Drawer(
        child: ListView(
          children: [
            //Cabecera
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://placehold.co/150'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dr/a. ${user!.name}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${user.specialty}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            //Botones de Navegación
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Pacientes'),
              onTap: () {
                Navigator.pushNamed(context, '/doctor-patients');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Citas'),
              onTap: () {
                Navigator.pushNamed(context, '/doctor-appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pushNamed(context, '/doctor-settings');
              },
            ),
          ],
        ),
      ),

      //Página Principal
      body: Stack(
        children: [
          //Fondo de pagina
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sección de bienvenida

                AspectRatio(
                      aspectRatio: 16 / 9, // Ajusta esta relación (ancho/alto)    child: Image.asset(
                      child: Image.asset('lib/assets/logo_mediconnect.png',
                      fit: BoxFit.contain, // Mantiene proporciones sin recortar
                    )),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenid@, Dr/a. ${user.name}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Horario de hoy: 9:00 AM - 5:00 PM',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de citas con manejo de estados
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        //Titulo Proximas Citas
                        Text(
                          'Próximas citas',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildFilterIndicator(),
                        const SizedBox(height: 10),

                        //Simbolo de carga
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        //Muestra Error en Pantalla y boton de refresco
                        else if (errorMessage != null)
                          Center(
                            child: Column(
                              children: [
                                Text(errorMessage!),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    final authCubit = context.read<AuthCubit>();
                                    final user = authCubit.currentDoctorUser;

                                    if (user != null) {
                                      fetchAppointments(user.id);
                                    } else {
                                      setState(() {
                                        errorMessage = 'Usuario no encontrado';
                                      });
                                    }
                                  },
                                  child: Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        //Mensaje si no hay ninguna cita
                        else if (appointmentsFounds.isEmpty)
                          const Center(child: Text('No tienes ninguna cita.'))
                        //Se encontraron las citas y se muestran
                        else
                          ListView.builder(
                            itemCount: appointmentsFounds.length,
                            itemBuilder: (context, index) {
                              final appointment = appointmentsFounds[index];
                              return AppointmentItem(
                                patientName:
                                    appointment.patientName ??
                                    "No tiene nombre",
                                time: DateFormat(
                                  'yyyy-MM-dd',
                                ).format(appointment.date),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Botones Fijos
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  //Boton de filtrar
                  FloatingActionButton(
                    heroTag: 'filter',
                    backgroundColor: AppColors.primary,
                    onPressed: () => _showDateRangePicker(context),
                    child: const Icon(Icons.filter_alt, color: Colors.white),
                  ),
                  const SizedBox(width: 32),

                  //Boton de añadir cita
                  FloatingActionButton(
                    heroTag: 'add',
                    backgroundColor: AppColors.secondary,
                    onPressed: _showAddAppointmentDialog,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
