
import 'package:flutter/material.dart';

//Widget para mostrar cada cita en la lista de citas
class AppointmentItem extends StatelessWidget {
  final String patientName;
  final String time;

  const AppointmentItem({super.key, 
    required this.patientName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          
          //Icon de Usuario
          const Icon(Icons.person, size: 40),
          const SizedBox(width: 10),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Nombre del Paciente
                Text(
                  patientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                //Hora de la Cita
                Text(time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}