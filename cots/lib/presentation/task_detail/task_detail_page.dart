import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../core/services/task_service.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget.task.isDone;
  }

  String getDisplayStatus() {
    if (isDone) return 'SELESAI';

    final now = DateTime.now();
    final deadline = DateTime(
      widget.task.deadline.year,
      widget.task.deadline.month,
      widget.task.deadline.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    if (deadline.isBefore(today)) return 'TERLAMBAT';
    return 'BERJALAN';
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    final status = getDisplayStatus();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text('Detail Tugas', style: AppText.title),
        leading: BackButton(color: AppColors.text),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul Tugas', style: AppText.caption),
            Text(t.title, style: AppText.section),

            const SizedBox(height: AppSpacing.m),
            Text('Mata Kuliah', style: AppText.caption),
            Text(t.course, style: AppText.body),

            const SizedBox(height: AppSpacing.m),
            Text('Deadline', style: AppText.caption),
            Text(t.deadlineFormatted, style: AppText.body),

            const SizedBox(height: AppSpacing.m),
            Text('Status', style: AppText.caption),
            _statusBadge(status),

            const SizedBox(height: AppSpacing.l),
            Text('Penyelesaian', style: AppText.section),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Tugas sudah selesai', style: AppText.body),
              value: isDone,
              onChanged: (v) {
                setState(() => isDone = v ?? false);
              },
            ),

            const SizedBox(height: AppSpacing.l),
            Text('Catatan', style: AppText.section),
            const SizedBox(height: AppSpacing.s),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                t.note.isEmpty ? '-' : t.note,
                style: AppText.body,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await TaskService.updateTask(
                    t.id,
                    {
                      'is_done': isDone,
                      'status': isDone ? 'SELESAI' : 'BERJALAN',
                    },
                  );

                  Navigator.pop(context, true);
                },
                child: Text('Simpan Perubahan', style: AppText.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    if (status == 'SELESAI') {
      color = Colors.green;
    } else if (status == 'TERLAMBAT') {
      color = AppColors.danger;
    } else {
      color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppText.caption.copyWith(color: color),
      ),
    );
  }
}
