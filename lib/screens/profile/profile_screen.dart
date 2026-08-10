import 'package:flutter/material.dart';

import '../../services/session_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    SessionManager.clearSession();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name =
        SessionManager.fullName ?? "User";

    final String email =
        SessionManager.email ?? "No Email";

    final String userId =
        SessionManager.userId?.toString() ?? "Unknown";

    final String initial = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : "U";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            // PROFILE AVATAR
            CircleAvatar(
              radius: 50,
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NAME
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // EMAIL
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // ACCOUNT INFORMATION
            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                    ),
                    title: const Text(
                      "Full Name",
                    ),
                    subtitle: Text(
                      name,
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.email,
                    ),
                    title: const Text(
                      "Email",
                    ),
                    subtitle: Text(
                      email,
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.badge,
                    ),
                    title: const Text(
                      "User ID",
                    ),
                    subtitle: Text(
                      userId,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // LOGOUT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  "Logout",
                ),
                onPressed: () {
                  _logout(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}