import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/api_service.dart';
import '../../services/session_manager.dart';
import '../../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;
  int highPriorityTasks = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (SessionManager.userId == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    final result = await ApiService.getDashboardStats(
      userId: SessionManager.userId!,
    );

    if (!mounted) return;

    if (result["success"] == true) {
      final data = result["data"];

      setState(() {
        totalTasks = int.tryParse(data["total"].toString()) ?? 0;
        completedTasks = int.tryParse(data["completed"].toString()) ?? 0;
        pendingTasks = int.tryParse(data["pending"].toString()) ?? 0;
        highPriorityTasks = int.tryParse(data["high"].toString()) ?? 0;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result["message"]?.toString() ?? "Unable to load dashboard",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final String userName = SessionManager.fullName ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskFlow Pro"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Good Morning 👋",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's organize your work today.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Today's Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                        children: [
                          DashboardCard(
                            title: "Total Tasks",
                            value: totalTasks.toString(),
                            icon: Icons.task_alt,
                            color: Colors.blue,
                          ),
                          DashboardCard(
                            title: "Completed",
                            value: completedTasks.toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                          DashboardCard(
                            title: "Pending",
                            value: pendingTasks.toString(),
                            icon: Icons.schedule,
                            color: Colors.orange,
                          ),
                          DashboardCard(
                            title: "High Priority",
                            value: highPriorityTasks.toString(),
                            icon: Icons.priority_high,
                            color: Colors.red,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Task Status Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 230,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 55,
                                    sections: [
                                      PieChartSectionData(
                                        value: completedTasks.toDouble(),
                                        title: "Completed",
                                        radius: 65,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        color: Colors.green,
                                      ),
                                      PieChartSectionData(
                                        value: pendingTasks.toDouble(),
                                        title: "Pending",
                                        radius: 65,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        color: Colors.orange,
                                      ),
                                      PieChartSectionData(
                                        value: highPriorityTasks.toDouble(),
                                        title: "High",
                                        radius: 65,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildLegend(
                                    "Completed",
                                    Colors.green,
                                  ),
                                  _buildLegend(
                                    "Pending",
                                    Colors.orange,
                                  ),
                                  _buildLegend(
                                    "High Priority",
                                    Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
