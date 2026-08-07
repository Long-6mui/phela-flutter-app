import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../services/auth_storage.dart';

class DebugClearDB extends StatelessWidget {
  const DebugClearDB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Tools')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.clearAllUsers();
                await AuthStorage.clearSession();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa tất cả users!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Xóa tất cả users'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteDatabase();
                await AuthStorage.clearSession();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa toàn bộ database!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Xóa toàn bộ database'),
            ),
          ],
        ),
      ),
    );
  }
}
