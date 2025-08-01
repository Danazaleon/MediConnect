import 'package:flutter/material.dart';
import 'package:medi_connect/widgets/appointment_item.dart';
import 'package:medi_connect/widgets/summary_dard.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Médico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Cerrar sesión
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://placehold.co/150'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dr. Alejandro Pérez',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Cardiólogo',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de bienvenida
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido, Dr. Pérez',
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
            
            // Resumen rápido
            Row(
              children: [
                SummaryCard(
                  icon: Icons.people,
                  value: '12',
                  label: 'Pacientes hoy',
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                SummaryCard(
                  icon: Icons.timer,
                  value: '3',
                  label: 'Pendientes',
                  color: Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Próximas citas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Próximas citas',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppointmentItem(
                      patient: 'María Gutiérrez',
                      time: '10:30 AM',
                      status: 'Confirmada',
                    ),
                    AppointmentItem(
                      patient: 'Carlos Martínez',
                      time: '11:15 AM',
                      status: 'Pendiente',
                    ),
                    AppointmentItem(
                      patient: 'Lucía Fernández',
                      time: '2:00 PM',
                      status: 'Confirmada',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}