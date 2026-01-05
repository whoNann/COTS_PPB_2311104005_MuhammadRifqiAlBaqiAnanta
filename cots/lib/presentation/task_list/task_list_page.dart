import 'package:flutter/material.dart';
import '../../core/services/task_service.dart';
import '../../data/models/task_model.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String selectedFilter = 'SEMUA';
  String searchQuery = '';

  String getDisplayStatus(TaskModel task) {
    if (task.isDone) return 'SELESAI';

    final now = DateTime.now();
    final deadline =
        DateTime(task.deadline.year, task.deadline.month, task.deadline.day);
    final today = DateTime(now.year, now.month, now.day);

    if (deadline.isBefore(today)) return 'TERLAMBAT';
    return 'BERJALAN';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text('Daftar Tugas', style: AppText.title),
        leading: BackButton(color: AppColors.text),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add');
              if (result == true) setState(() {});
            },
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: Text('Tambah',
                style: AppText.body.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            _searchField(),
            const SizedBox(height: AppSpacing.s),
            _filterChips(),
            const SizedBox(height: AppSpacing.m),
            Expanded(
              child: FutureBuilder<List<TaskModel>>(
                future: TaskService.getTasks(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final all = snapshot.data!;
                  final filtered = all.where((task) {
                    final status = getDisplayStatus(task);

                    final matchFilter = selectedFilter == 'SEMUA' ||
                        status == selectedFilter;

                    final matchSearch =
                        task.title.toLowerCase().contains(searchQuery) ||
                            task.course.toLowerCase().contains(searchQuery);

                    return matchFilter && matchSearch;
                  }).toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final task = filtered[i];
                      final status = getDisplayStatus(task);

                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: task,
                          );
                          if (result == true) setState(() {});
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
                                    Text(task.course,
                                        style: AppText.caption),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(task.deadlineShort,
                                      style: AppText.caption),
                                  const SizedBox(height: 4),
                                  _statusBadge(status),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      onChanged: (value) {
        setState(() => searchQuery = value.toLowerCase());
      },
      decoration: InputDecoration(
        hintText: 'Cari tugas atau mata kuliah...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _filterChips() {
    final filters = ['SEMUA', 'BERJALAN', 'SELESAI', 'TERLAMBAT'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final selected = selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: selected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.text,
              ),
              onSelected: (_) {
                setState(() => selectedFilter = f);
              },
            ),
          );
        }).toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
