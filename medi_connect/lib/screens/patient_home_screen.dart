import 'package:flutter/material.dart';

class PatientHomeScreen extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      id: 1,
      name: 'Dr. Carlos Mendoza',
      specialty: 'Cardiología',
      rating: 4.8,
      email: 'carlos.mendoza@example.com',
    ),
    Doctor(
      id: 2,
      name: 'Dra. Ana López',
      specialty: 'Pediatría',
      rating: 4.9,
      email: 'ana.lopez@example.com',
    ),
    Doctor(
      id: 3,
      name: 'Dr. Javier Ruiz',
      specialty: 'Ortopedia',
      rating: 4.7,
      email: 'javier.ruiz@example.com',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médicos Disponibles'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://placehold.co/150'),
              ),
              title: Text(doctor.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.specialty),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${doctor.rating.toStringAsFixed(1)}'),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDoctorProfile(context, doctor);
              },
            ),
          );
        },
      ),
    );
  }

  void _showDoctorProfile(BuildContext context, Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://placehold.co/150'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      doctor.specialty,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailItem(Icons.email, doctor.email),
              const SizedBox(height: 16),
              _buildDetailItem(Icons.star, 'Calificación: ${doctor.rating.toStringAsFixed(1)}'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text('Iniciar Chat'),
                  onPressed: () {
                    _showChatModal(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16),
        Text(text),
      ],
    );
  }

  void _showChatModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chat con el médico'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Esta funcionalidad estará disponible próximamente.'),
              SizedBox(height: 16),
              Text('(Simulación de chat)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class Doctor {
  final int id;
  final String name;
  final String specialty;
  final double rating;
  final String email;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.email,
  });
}