import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart' show AppColors;
import 'package:medi_connect/models/doctor.dart';
import 'package:medi_connect/widgets/build_detail_item.dart';
import 'package:medi_connect/widgets/constuction_dialog.dart';

void showDoctorProfile(BuildContext context, Doctor doctor) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  //Imagen Ficticia para el perfil del médico
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://placehold.co/150'),
                  ),
                  const SizedBox(height: 16),

                  //Nombre del médico
                  Text(
                    doctor.name ?? 'Nombre no disponible', // Manejo de null
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  //Especialidad del médico
                  Text(
                    doctor.specialty ??
                        'Especialidad no disponible', // Manejo de null
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),

                  //Correo del médico
                  buildDetailItem(Icons.email, doctor.email),
                  const SizedBox(height: 16),

                  //Calificación del médico
                  buildDetailItem(
                    Icons.star,
                    'Calificación: ${doctor.rating != null ? doctor.rating!.toStringAsFixed(1) : 'N/A'}',
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, // Padding horizontal
                    vertical: 24.0, // Padding vertical
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16.0, // Tamaño medio
                    fontWeight: FontWeight.w500, // Grosor mediano
                  ),
                  elevation: 4, // Sombra ligera
                ),
                icon: const Icon(Icons.chat),
                label: const Text(
                  'Iniciar Chat',
                  selectionColor: AppColors.grey,
                ),
                onPressed: () {
                  showConstructionDialog(
                    context,
                    'Chat con el médico',
                    'Esta funcionalidad estará disponible próximamente.',
                    '(Simulación de chat)',
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
