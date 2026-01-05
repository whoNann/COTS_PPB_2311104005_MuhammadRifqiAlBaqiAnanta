class TaskModel {
  final int id;
  final String title;
  final String course;
  final DateTime deadline;
  final String status;
  final String note;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
    required this.note,
    required this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      course: json['course'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      note: json['note'] ?? '',
      isDone: json['is_done'] ?? false,
    );
  }

  // ==========================
  // 🔥 GETTER TAMBAHAN (INI KUNCINYA)
  // ==========================

  /// Contoh: 18 Jan 2026
  String get deadlineFormatted {
    return '${deadline.day.toString().padLeft(2, '0')} '
        '${_monthName(deadline.month)} '
        '${deadline.year}';
  }

  /// Contoh: 18 Jan
  String get deadlineShort {
    return '${deadline.day.toString().padLeft(2, '0')} '
        '${_monthName(deadline.month)}';
  }

  // ==========================
  // Helper
  // ==========================
  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }
}
