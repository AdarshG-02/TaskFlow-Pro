import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session_manager.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _employeeController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  final TextEditingController _statusPercentageController =
      TextEditingController(text: "0");

  DateTime? _transactionDate;
  DateTime? _startDate;
  DateTime? _endDate;

  String _priority = "Medium";
  String _status = "Not Started";

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _projectController.dispose();
    _clientController.dispose();
    _employeeController.dispose();
    _descriptionController.dispose();
    _statusPercentageController.dispose();
    super.dispose();
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

  Future<void> _saveTask() async {
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

    if (_transactionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select transaction date."),
        ),
      );
      return;
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select task start date."),
        ),
      );
      return;
    }

    if (_endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select task end date."),
        ),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Task end date cannot be before start date.",
          ),
        ),
      );
      return;
    }

    final statusPercentage =
        int.tryParse(_statusPercentageController.text.trim());

    if (statusPercentage == null ||
        statusPercentage < 0 ||
        statusPercentage > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status % must be between 0 and 100."),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.addTask(
      userId: SessionManager.userId!,
      transactionDate: _formatDate(_transactionDate!),
      project: _projectController.text.trim(),
      client: _clientController.text.trim(),
      assignedEmployee: _employeeController.text.trim(),
      title: _titleController.text.trim(),
      startDate: _formatDate(_startDate!),
      endDate: _formatDate(_endDate!),
      priority: _priority,
      status: _status,
      statusPercentage: statusPercentage,
      description: _descriptionController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
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
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TRANSACTION DATE
              _dateField(
                label: "Transaction Date",
                date: _transactionDate,
                onTap: () {
                  _selectDate(
                    currentDate: _transactionDate,
                    onSelected: (date) {
                      _transactionDate = date;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // PROJECT
              TextFormField(
                controller: _projectController,
                decoration: const InputDecoration(
                  labelText: "Project",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // CLIENT
              TextFormField(
                controller: _clientController,
                decoration: const InputDecoration(
                  labelText: "Client",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // ASSIGNED EMPLOYEE
              TextFormField(
                controller: _employeeController,
                decoration: const InputDecoration(
                  labelText: "Assigned Employee",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // SUBJECT
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter subject";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // START DATE
              _dateField(
                label: "Task Start Date",
                date: _startDate,
                onTap: () {
                  _selectDate(
                    currentDate: _startDate,
                    onSelected: (date) {
                      _startDate = date;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // END DATE
              _dateField(
                label: "Task End Date",
                date: _endDate,
                onTap: () {
                  _selectDate(
                    currentDate: _endDate,
                    onSelected: (date) {
                      _endDate = date;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // PRIORITY
              DropdownButtonFormField<String>(
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
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
                      _priority = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // STATUS
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
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
                      _status = value;

                      if (_status == "Not Started") {
                        _statusPercentageController.text = "0";
                      } else if (_status == "Completed") {
                        _statusPercentageController.text = "100";
                      }
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // STATUS %
              TextFormField(
                controller: _statusPercentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Status %",
                  hintText: "0 - 100",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final percentage = int.tryParse(value?.trim() ?? "");

                  if (percentage == null ||
                      percentage < 0 ||
                      percentage > 100) {
                    return "Enter a value between 0 and 100";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // REMARKS
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: _saveTask,
                        child: const Text(
                          "Save Task",
                          style: TextStyle(
                            fontSize: 18,
                          ),
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