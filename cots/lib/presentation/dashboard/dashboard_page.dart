import 'package:flutter/material.dart';
import '../../core/services/task_service.dart';
import '../../data/models/task_model.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text('Tugas Besar', style: AppText.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/tasks');
            },
            child: Text(
              'Daftar Tugas',
              style: AppText.body.copyWith(color: AppColors.primary),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: FutureBuilder<List<TaskModel>>(
          future: TaskService.getTasks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final tasks = snapshot.data!;
            final completed = tasks.where((t) => t.isDone).length;
            final nearest = tasks.take(3).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _summaryCard('Total Tugas', tasks.length.toString()),
                    const SizedBox(width: AppSpacing.m),
                    _summaryCard('Selesai', completed.toString()),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                Text('Tugas Terdekat', style: AppText.section),
                const SizedBox(height: AppSpacing.s),
                ...nearest.map((task) => _taskCard(context, task)),
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/add');
                    },
                    child: Text('Tambah Tugas', style: AppText.button),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.caption),
            const SizedBox(height: 4),
            Text(value, style: AppText.title),
          ],
        ),
      ),
    );
  }

  Widget _taskCard(BuildContext context, TaskModel task) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: task);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s),
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: AppText.body),
                  Text(task.course, style: AppText.caption),
                  Text('Deadline: ${task.deadlineFormatted}',
                      style: AppText.caption),
                ],
              ),
            ),
            _statusBadge(task.status),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppText.caption.copyWith(color: AppColors.primary),
      ),
    );
  }
}
