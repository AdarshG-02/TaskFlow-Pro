import 'package:flutter/material.dart';
import 'edit_task_screen.dart';

import '../../services/api_service.dart';
import '../../services/session_manager.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool isLoading = true;
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    if (SessionManager.userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await ApiService.getTasks(
      userId: SessionManager.userId!,
    );

    if (!mounted) return;

    if (result["success"] == true) {
      setState(() {
        tasks = result["data"] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result["message"] ?? "Failed to load tasks",
          ),
        ),
      );
    }
  }

  Future<void> deleteTask(Map<String, dynamic> task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text(
          "Are you sure you want to delete this task?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await ApiService.deleteTask(
      id: int.parse(task["id"].toString()),
      userId: SessionManager.userId!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["message"] ?? "Something went wrong",
        ),
      ),
    );

    if (result["success"] == true) {
      loadTasks();
    }
  }

  Future<void> completeTask(Map<String, dynamic> task) async {
    if (task["status"] == "Completed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task is already completed."),
        ),
      );
      return;
    }

    final result = await ApiService.completeTask(
      id: int.parse(task["id"].toString()),
      userId: SessionManager.userId!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["message"] ?? "Something went wrong",
        ),
      ),
    );

    if (result["success"] == true) {
      loadTasks();
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

  Widget infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: value.isEmpty ? "-" : value,
                  ),
                ],
              ),
            ),
          ),
        ],
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

    if (tasks.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("All Tasks"),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: loadTasks,
          child: ListView(
            children: const [
              SizedBox(height: 250),
              Center(
                child: Text(
                  "No Tasks Found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: loadTasks,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            final String priority =
                task["priority"]?.toString() ?? "Medium";

            final String status =
                task["status"]?.toString() ?? "Not Started";

            final String statusPercentage =
                task["status_percentage"]?.toString() ?? "0";

            final String description =
                task["description"]?.toString() ?? "";

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskScreen(
                        task: task,
                      ),
                    ),
                  );

                  loadTasks();
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                getPriorityColor(priority),
                            child: const Icon(
                              Icons.task_alt,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task["title"]?.toString() ??
                                      "Untitled Task",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getPriorityColor(
                                          priority,
                                        ).withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        priority,
                                        style: TextStyle(
                                          color:
                                              getPriorityColor(
                                            priority,
                                          ),
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          status,
                                        ).withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color:
                                              getStatusColor(
                                            status,
                                          ),
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      const Divider(),

                      const SizedBox(height: 10),

                      // TASK INFORMATION
                      infoRow(
                        Icons.work,
                        "Project",
                        task["project"]?.toString() ?? "",
                      ),

                      infoRow(
                        Icons.business,
                        "Client",
                        task["client"]?.toString() ?? "",
                      ),

                      infoRow(
                        Icons.person,
                        "Assigned Employee",
                        task["assigned_employee"]?.toString() ?? "",
                      ),

                      infoRow(
                        Icons.event,
                        "Transaction Date",
                        task["transaction_date"]?.toString() ?? "",
                      ),

                      infoRow(
                        Icons.play_arrow,
                        "Start Date",
                        task["start_date"]?.toString() ?? "",
                      ),

                      infoRow(
                        Icons.stop,
                        "End Date",
                        task["end_date"]?.toString() ?? "",
                      ),

                      const SizedBox(height: 8),

                      // STATUS PROGRESS
                      Text(
                        "Progress: $statusPercentage%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      LinearProgressIndicator(
                        value:
                            (int.tryParse(statusPercentage) ?? 0) /
                                100,
                      ),

                      // REMARKS
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        infoRow(
                          Icons.description,
                          "Remarks",
                          description,
                        ),
                      ],

                      const SizedBox(height: 8),

                      // ACTION BUTTONS
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            tooltip: "Mark Complete",
                            onPressed: () {
                              completeTask(task);
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            tooltip: "Edit Task",
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTaskScreen(
                                    task: task,
                                  ),
                                ),
                              );

                              loadTasks();
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            tooltip: "Delete Task",
                            onPressed: () {
                              deleteTask(task);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}