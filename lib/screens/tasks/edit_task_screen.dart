import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session_manager.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController projectController;
  late TextEditingController clientController;
  late TextEditingController employeeController;
  late TextEditingController descriptionController;
  late TextEditingController statusPercentageController;

  DateTime? transactionDate;
  DateTime? startDate;
  DateTime? endDate;

  String priority = "Medium";
  String status = "Not Started";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.task["title"]?.toString() ?? "",
    );

    projectController = TextEditingController(
      text: widget.task["project"]?.toString() ?? "",
    );

    clientController = TextEditingController(
      text: widget.task["client"]?.toString() ?? "",
    );

    employeeController = TextEditingController(
      text: widget.task["assigned_employee"]?.toString() ?? "",
    );

    descriptionController = TextEditingController(
      text: widget.task["description"]?.toString() ?? "",
    );

    statusPercentageController = TextEditingController(
      text: widget.task["status_percentage"]?.toString() ?? "0",
    );

    final savedPriority = widget.task["priority"]?.toString();

    if (savedPriority == "High" ||
        savedPriority == "Medium" ||
        savedPriority == "Low") {
      priority = savedPriority!;
    }

    final savedStatus = widget.task["status"]?.toString();

    if (savedStatus == "Not Started" ||
        savedStatus == "In Progress" ||
        savedStatus == "Completed") {
      status = savedStatus!;
    }

    transactionDate = _parseDate(widget.task["transaction_date"]);
    startDate = _parseDate(widget.task["start_date"]);
    endDate = _parseDate(widget.task["end_date"]);
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();

    if (text.isEmpty || text == "null") {
      return null;
    }

    return DateTime.tryParse(text);
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return "$year-$month-$day";
  }

  Future<void> _selectDate({
    required DateTime? currentDate,
    required Function(DateTime) onSelected,
  }) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        onSelected(selectedDate);
      });
    }
  }

  Future<void> updateTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (SessionManager.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User session not found. Please login again."),
        ),
      );
      return;
    }

    if (transactionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select transaction date."),
        ),
      );
      return;
    }

    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select task start date."),
        ),
      );
      return;
    }

    if (endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select task end date."),
        ),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Task end date cannot be before start date.",
          ),
        ),
      );
      return;
    }

    final percentage =
        int.tryParse(statusPercentageController.text.trim());

    if (percentage == null || percentage < 0 || percentage > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status % must be between 0 and 100."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.updateTask(
      id: int.parse(widget.task["id"].toString()),
      userId: SessionManager.userId!,
      transactionDate: _formatDate(transactionDate!),
      project: projectController.text.trim(),
      client: clientController.text.trim(),
      assignedEmployee: employeeController.text.trim(),
      title: titleController.text.trim(),
      startDate: _formatDate(startDate!),
      endDate: _formatDate(endDate!),
      priority: priority,
      status: status,
      statusPercentage: percentage,
      description: descriptionController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["message"] ?? "Something went wrong.",
        ),
      ),
    );

    if (result["success"] == true) {
      Navigator.pop(context, true);
    }
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          date == null ? "Select date" : _formatDate(date),
          style: TextStyle(
            color: date == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    projectController.dispose();
    clientController.dispose();
    employeeController.dispose();
    descriptionController.dispose();
    statusPercentageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TRANSACTION DATE
              _dateField(
                label: "Transaction Date",
                date: transactionDate,
                icon: Icons.event,
                onTap: () {
                  _selectDate(
                    currentDate: transactionDate,
                    onSelected: (date) {
                      transactionDate = date;
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // PROJECT
              TextFormField(
                controller: projectController,
                decoration: const InputDecoration(
                  labelText: "Project",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
              ),

              const SizedBox(height: 20),

              // CLIENT
              TextFormField(
                controller: clientController,
                decoration: const InputDecoration(
                  labelText: "Client",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),

              const SizedBox(height: 20),

              // ASSIGNED EMPLOYEE
              TextFormField(
                controller: employeeController,
                decoration: const InputDecoration(
                  labelText: "Assigned Employee",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              // SUBJECT
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter subject";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // START DATE
              _dateField(
                label: "Task Start Date",
                date: startDate,
                icon: Icons.play_arrow,
                onTap: () {
                  _selectDate(
                    currentDate: startDate,
                    onSelected: (date) {
                      startDate = date;
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // END DATE
              _dateField(
                label: "Task End Date",
                date: endDate,
                icon: Icons.stop,
                onTap: () {
                  _selectDate(
                    currentDate: endDate,
                    onSelected: (date) {
                      endDate = date;
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // PRIORITY
              DropdownButtonFormField<String>(
                initialValue: priority,
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "High",
                    child: Text("High"),
                  ),
                  DropdownMenuItem(
                    value: "Medium",
                    child: Text("Medium"),
                  ),
                  DropdownMenuItem(
                    value: "Low",
                    child: Text("Low"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      priority = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // STATUS
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.task_alt),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Not Started",
                    child: Text("Not Started"),
                  ),
                  DropdownMenuItem(
                    value: "In Progress",
                    child: Text("In Progress"),
                  ),
                  DropdownMenuItem(
                    value: "Completed",
                    child: Text("Completed"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      status = value;

                      if (status == "Not Started") {
                        statusPercentageController.text = "0";
                      } else if (status == "Completed") {
                        statusPercentageController.text = "100";
                      }
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // STATUS %
              TextFormField(
                controller: statusPercentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Status %",
                  hintText: "0 - 100",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                validator: (value) {
                  final percentage =
                      int.tryParse(value?.trim() ?? "");

                  if (percentage == null ||
                      percentage < 0 ||
                      percentage > 100) {
                    return "Enter a value between 0 and 100";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // REMARKS
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),

              const SizedBox(height: 35),

              // UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : updateTask,
                  icon: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    isLoading ? "Updating..." : "Update Task",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}