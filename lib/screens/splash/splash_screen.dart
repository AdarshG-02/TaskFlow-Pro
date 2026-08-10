import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_rounded,
              color: Colors.white,
              size: 90,
            ),
            SizedBox(height: 20),
            Text(
              'TaskFlow Pro',
              style: AppTextStyles.headline.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Professional Task Management',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}