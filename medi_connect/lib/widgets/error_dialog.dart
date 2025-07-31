import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart';

void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: const Color.fromARGB(255, 149, 4, 4),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: AppColors.black),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ),
        ],
      ),
    );
  }

