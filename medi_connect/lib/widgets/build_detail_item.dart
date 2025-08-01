
import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart';

Widget buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(width: 16),
        Text(text),
      ],
    );
  }
