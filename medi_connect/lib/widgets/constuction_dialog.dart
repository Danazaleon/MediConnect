
  
  import 'package:flutter/material.dart';
import 'package:medi_connect/constants/app_colors.dart';

void showConstructionDialog(BuildContext context,String title,String message, String simulation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style:TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700) ,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 16),
              Text(simulation),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.white, backgroundColor: AppColors.primary),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

