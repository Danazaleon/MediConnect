import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:medi_connect/constants/app_colors.dart';
import 'package:medi_connect/controllers/api.controller.dart';
import 'package:medi_connect/cubits/auth/auth_cubit.dart';
import 'package:medi_connect/functions/parses.dart';
import 'package:medi_connect/models/doctor.dart';
import 'package:medi_connect/widgets/constuction_dialog.dart';
import 'package:medi_connect/widgets/show_doctor_profile.dart';

// Pantalla de inicio para pacientes
// Muestra un listado de doctores registrados y permite al paciente ver sus perfiles
class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreen();
}

// Estado que maneja la lógica de búsqueda y filtrado
class _PatientHomeScreen extends State<PatientHomeScreen> {
  List<Doctor> doctorsFounds = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    Logger().i(doctorsFounds); // Llama a fetchDoctors al iniciar la pantalla
  }

  void fetchDoctors() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      var json = await getDoctors();

      setState(() {
        doctorsFounds = json != null ? parseDoctors(json) : [];
        Logger().i("Despues del parse");
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar doctores';
        isLoading = false;
      });
      debugPrint('Error cargando doctores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>(); // Accede al AuthCubit

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        Logger().i('AuthState actual: $state'); // <-- Para debug
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AuthError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is AuthSuccess || state is PatientAuthenticated) {
          final user = authCubit.currentPatientUser;

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
                //Botón de Busqueda
                IconButton(
                  icon: const Icon(Icons.search),
                  color: AppColors.white,
                  onPressed: () {
                    showConstructionDialog(
                      context,
                      'Busqueda de médicos',
                      'Esta funcionalidad estará disponible próximamente.',
                      '(Simulación de Busqueda)',
                    );
                  },
                ),
                SizedBox(width: 16),
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
                        const SizedBox(height: 20),
                        Text(
                          user?.name ?? 'Nombre no disponible',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
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
                    leading: const Icon(Icons.settings),
                    title: const Text('Configuración'),
                    onTap: () {
                      Navigator.pushNamed(context, '/doctor-settings');
                    },
                  ),
                ],
              ),
            ),

            //Página de
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9, // Ajusta esta relación (ancho/alto)    child: Image.asset(
                            child: Image.asset('lib/assets/logo_mediconnect.png',
                            fit: BoxFit.contain, // Mantiene proporciones sin recortar
                          )),
                          const SizedBox(height: 20),
                          Text(
                            user?.name != null
                                ? 'Bienvenid@, ${user!.name}'
                                : 'Bienvenid@',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Médicos Registrados',
                    style: TextStyle(
                      fontSize: 28.0, // Tamaño grande
                      fontWeight: FontWeight.w700, // Negrita
                      color: AppColors.primary, // Color llamativo
                    ),
                    textAlign: TextAlign.left, // Centrado horizontal
                  ),
                  const SizedBox(height: 10),
                  // Sección de doctores con manejo de estados
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (errorMessage != null)
                    Center(
                      child: Column(
                        children: [
                          Text(errorMessage!),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: fetchDoctors,
                            child: Text('Reintentar $errorMessage'),
                          ),
                        ],
                      ),
                    )
                  else if (doctorsFounds.isEmpty)
                    const Center(child: Text('No se encontraron doctores'))
                  else
                    ListView.builder(
                      itemCount: doctorsFounds.length,
                      itemBuilder: (context, index) {
                        final doctor = doctorsFounds[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://placehold.co/150',
                              ),
                            ),
                            title: Text(
                              doctor.name ?? 'Nombre no disponible',
                            ), // Manejo de null
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.specialty ?? 'Especialidad no disponible',
                                ), // Manejo de null
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      ' ${doctor.rating?.toStringAsFixed(1) ?? 'N/A'}',
                                    ) // Manejo de null
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              showDoctorProfile(context, doctor);
                            },
                          ),
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                ],
              ),
            ),
          );
        } else if (state is AuthInitial) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(child: Text('Estado desconocido: ${state.runtimeType}'));
      },
    );
  }
}

