import 'package:flutter/material.dart';
import 'presentation/dashboard/dashboard_page.dart';
import 'presentation/task_list/task_list_page.dart';
import 'presentation/task_add/task_add_page.dart';
import 'presentation/task_detail/task_detail_page.dart';
import 'data/models/task_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => DashboardPage(),
        '/tasks': (_) => TaskListPage(),
        '/add': (_) => TaskAddPage(),
        '/detail': (context) {
          final task =
              ModalRoute.of(context)!.settings.arguments as TaskModel;
          return TaskDetailPage(task: task);
        },
      },
    );
  }
}
