import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';
import '../../data/models/task_model.dart';

class TaskService {
  static const String _basePath = '/rest/v1/tasks';

  static Map<String, String> _headers() {
    return {
      'apikey': SupabaseConfig.anonKey,
      'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    };
  }

  // GET ALL TASKS
  static Future<List<TaskModel>> getTasks() async {
    final response = await http.get(
      Uri.parse('${SupabaseConfig.baseUrl}$_basePath?select=*'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gagal GET tasks: ${response.body}');
    }

    final List data = json.decode(response.body);
    return data.map((e) => TaskModel.fromJson(e)).toList();
  }

  // POST ADD TASK
  static Future<void> addTask(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('${SupabaseConfig.baseUrl}$_basePath'),
      headers: _headers(),
      body: json.encode(body),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gagal POST task: ${response.body}');
    }
  }

  // PATCH UPDATE TASK
  static Future<void> updateTask(int id, Map<String, dynamic> body) async {
    final response = await http.patch(
      Uri.parse('${SupabaseConfig.baseUrl}$_basePath?id=eq.$id'),
      headers: _headers(),
      body: json.encode(body),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gagal PATCH task: ${response.body}');
    }
  }
}
