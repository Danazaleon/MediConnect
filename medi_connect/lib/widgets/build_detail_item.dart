
import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart';

// Construye un elemento de detalle con un ícono y texto
Widget buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(width: 16),
        Text(text),
      ],
    );
  }
