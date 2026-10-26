import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
    "https://taskflow-pro-backend-vercel.vercel.app/api";
// REGISTER USER
  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          "full_name": fullName,
          "email": email,
          "password": password,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": "Unable to connect to server."
      };
    }
  }

  // LOGIN USER
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          "email": email,
          "password": password,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": "Unable to connect to server."
      };
    }
  }

  // ADD TASK
static Future<Map<String, dynamic>> addTask({
  required int userId,
  required String transactionDate,
  required String project,
  required String client,
  required String assignedEmployee,
  required String title,
  required String startDate,
  required String endDate,
  required String priority,
  required String status,
  required int statusPercentage,
  required String description,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/add_task.php"),
      body: {
        "user_id": userId.toString(),
        "transaction_date": transactionDate,
        "project": project,
        "client": client,
        "assigned_employee": assignedEmployee,
        "title": title,
        "start_date": startDate,
        "end_date": endDate,
        "priority": priority,
        "status": status,
        "status_percentage": statusPercentage.toString(),
        "description": description,
      },
    );

    return jsonDecode(response.body);
  } catch (e) {
    return {
      "success": false,
      "message": "Unable to connect to server."
    };
  }
}

  // GET TASKS
  static Future<Map<String, dynamic>> getTasks({
    required int userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_tasks.php"),
        body: {
          "user_id": userId.toString(),
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": "Unable to connect to server."
      };
    }
  }

// UPDATE TASK
static Future<Map<String, dynamic>> updateTask({
  required int id,
  required int userId,
  required String transactionDate,
  required String project,
  required String client,
  required String assignedEmployee,
  required String title,
  required String startDate,
  required String endDate,
  required String priority,
  required String status,
  required int statusPercentage,
  required String description,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/update_task.php"),
      body: {
        "id": id.toString(),
        "user_id": userId.toString(),
        "transaction_date": transactionDate,
        "project": project,
        "client": client,
        "assigned_employee": assignedEmployee,
        "title": title,
        "start_date": startDate,
        "end_date": endDate,
        "priority": priority,
        "status": status,
        "status_percentage": statusPercentage.toString(),
        "description": description,
      },
    );

    return jsonDecode(response.body);
  } catch (e) {
    return {
      "success": false,
      "message": "Unable to connect to server."
    };
  }
}

// DELETE TASK
static Future<Map<String, dynamic>> deleteTask({
  required int id,
  required int userId,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_task.php"),
      body: {
        "id": id.toString(),
        "user_id": userId.toString(),
      },
    );

    return jsonDecode(response.body);
  } catch (e) {
    return {
      "success": false,
      "message": "Unable to connect to server."
    };
  }
}

// COMPLETE TASK
static Future<Map<String, dynamic>> completeTask({
  required int id,
  required int userId,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/complete_task.php"),
      body: {
        "id": id.toString(),
        "user_id": userId.toString(),
      },
    );

    return jsonDecode(response.body);
  } catch (e) {
    return {
      "success": false,
      "message": "Unable to connect to server."
    };
  }
}

// DASHBOARD STATS
static Future<Map<String, dynamic>> getDashboardStats({
  required int userId,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/dashboard_stats.php"),
      body: {
        "user_id": userId.toString(),
      },
    );

    return jsonDecode(response.body);
  } catch (e) {
    return {
      "success": false,
      "message": "Unable to connect to server."
    };
  }
}

// FORGOT PASSWORD
static Future<Map<String, dynamic>> forgotPassword({
  required String email,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/forgot_password.php"),
      body: {
        "email": email,
        "new_password": newPassword,
      },
    );

    return jsonDecode(response.body);

  } catch (e) {
    return {
      "success": false,
      "message": "Unable to connect to server."
    };
  }
}
}