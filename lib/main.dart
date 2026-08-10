import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';


void main() {
  runApp(const TaskFlowProApp());
}


class TaskFlowProApp extends StatelessWidget {
  const TaskFlowProApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'TaskFlow Pro',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,


      initialRoute: '/login',


      routes: {

        '/login': (context) => const LoginScreen(),

        '/dashboard': (context) => const DashboardScreen(),

      },

    );

  }
}