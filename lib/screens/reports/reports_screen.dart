import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session_manager.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isLoading = true;

  List<dynamic> tasks = [];

  int totalTasks = 0;
  int completedTasks = 0;
  int inProgressTasks = 0;
  int notStartedTasks = 0;

  int highPriorityTasks = 0;
  int mediumPriorityTasks = 0;
  int lowPriorityTasks = 0;

  double completionPercentage = 0;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    if (SessionManager.userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final statsResult = await ApiService.getDashboardStats(
      userId: SessionManager.userId!,
    );

    final tasksResult = await ApiService.getTasks(
      userId: SessionManager.userId!,
    );

    if (!mounted) return;

    if (statsResult["success"] == true &&
        tasksResult["success"] == true) {
      final List<dynamic> loadedTasks =
          tasksResult["data"] ?? [];

      int completed = 0;
      int inProgress = 0;
      int notStarted = 0;

      int high = 0;
      int medium = 0;
      int low = 0;

      double totalPercentage = 0;

      for (final task in loadedTasks) {
        final String status =
            task["status"]?.toString() ?? "Not Started";

        final String priority =
            task["priority"]?.toString() ?? "Medium";

        final double percentage =
            double.tryParse(
                  task["status_percentage"]?.toString() ?? "0",
                ) ??
                0;

        totalPercentage += percentage;

        switch (status) {
          case "Completed":
            completed++;
            break;

          case "In Progress":
            inProgress++;
            break;

          case "Not Started":
            notStarted++;
            break;
        }

        switch (priority) {
          case "High":
            high++;
            break;

          case "Medium":
            medium++;
            break;

          case "Low":
            low++;
            break;
        }
      }

      setState(() {
        tasks = loadedTasks;

        totalTasks = loadedTasks.length;

        completedTasks = completed;
        inProgressTasks = inProgress;
        notStartedTasks = notStarted;

        highPriorityTasks = high;
        mediumPriorityTasks = medium;
        lowPriorityTasks = low;

        completionPercentage = loadedTasks.isEmpty
            ? 0
            : totalPercentage / loadedTasks.length;

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            statsResult["message"] ??
                tasksResult["message"] ??
                "Failed to load reports.",
          ),
        ),
      );
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;

      case "Medium":
        return Colors.orange;

      case "Low":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;

      case "In Progress":
        return Colors.orange;

      case "Not Started":
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  Widget reportCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 15,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: loadReports,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            // TASK SUMMARY
            sectionTitle("Task Summary"),

            reportCard(
              "Total Tasks",
              totalTasks.toString(),
              Icons.task_alt,
              Colors.blue,
            ),

            reportCard(
              "Completed",
              completedTasks.toString(),
              Icons.check_circle,
              Colors.green,
            ),

            reportCard(
              "In Progress",
              inProgressTasks.toString(),
              Icons.pending_actions,
              Colors.orange,
            ),

            reportCard(
              "Not Started",
              notStartedTasks.toString(),
              Icons.schedule,
              Colors.grey,
            ),

            const SizedBox(height: 15),

            // PRIORITY SUMMARY
            sectionTitle("Priority Summary"),

            reportCard(
              "High Priority",
              highPriorityTasks.toString(),
              Icons.warning,
              Colors.red,
            ),

            reportCard(
              "Medium Priority",
              mediumPriorityTasks.toString(),
              Icons.flag,
              Colors.orange,
            ),

            reportCard(
              "Low Priority",
              lowPriorityTasks.toString(),
              Icons.low_priority,
              Colors.green,
            ),

            const SizedBox(height: 15),

            // COMPLETION
            sectionTitle("Overall Progress"),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Average Task Completion",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          "${completionPercentage.toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: completionPercentage / 100,
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ACTIVE TASKS
            sectionTitle("Active Tasks"),

            if (tasks
                .where(
                  (task) =>
                      task["status"]?.toString() ==
                      "In Progress",
                )
                .isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    "No active tasks.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            ...tasks
                .where(
                  (task) =>
                      task["status"]?.toString() ==
                      "In Progress",
                )
                .map(
                  (task) {
                    final String priority =
                        task["priority"]?.toString() ??
                            "Medium";

                    final String percentage =
                        task["status_percentage"]
                                ?.toString() ??
                            "0";

                    return Card(
                      elevation: 2,
                      margin:
                          const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              getPriorityColor(priority),
                          child: const Icon(
                            Icons.task,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          task["title"]?.toString() ??
                              "Untitled Task",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          "${task["project"]?.toString() ?? "-"}"
                          " • "
                          "$percentage% completed",
                        ),

                        trailing: Icon(
                          Icons.circle,
                          size: 12,
                          color: getStatusColor(
                            "In Progress",
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}