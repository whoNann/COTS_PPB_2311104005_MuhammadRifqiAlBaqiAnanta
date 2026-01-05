import 'package:flutter/material.dart';
import '../../core/services/task_service.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class TaskAddPage extends StatefulWidget {
  const TaskAddPage({super.key});

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCourse = '';
  DateTime? deadline;
  bool isDone = false;
  bool titleError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text('Tambah Tugas', style: AppText.title),
        leading: BackButton(color: AppColors.text),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul Tugas', style: AppText.caption),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul tugas',
                errorText: titleError ? 'Judul tugas wajib diisi' : null,
              ),
            ),

            const SizedBox(height: AppSpacing.m),
            Text('Mata Kuliah', style: AppText.caption),
            DropdownButtonFormField<String>(
              items: ['Pemrograman Lanjut', 'UI Engineering']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => selectedCourse = v ?? '',
            ),

            const SizedBox(height: AppSpacing.m),
            Text('Deadline', style: AppText.caption),
            TextButton(
              onPressed: () async {
                deadline = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                setState(() {});
              },
              child: Text(
                deadline == null
                    ? 'Pilih tanggal'
                    : deadline!.toIso8601String().split('T').first,
              ),
            ),

            CheckboxListTile(
              title: Text('Tugas sudah selesai'),
              value: isDone,
              onChanged: (v) => setState(() => isDone = v ?? false),
            ),

            Text('Catatan', style: AppText.caption),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Catatan tambahan'),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (titleController.text.isEmpty ||
        selectedCourse.isEmpty ||
        deadline == null) {
      setState(() => titleError = true);
      return;
    }

    await TaskService.addTask({
      'title': titleController.text,
      'course': selectedCourse,
      'deadline': deadline!.toIso8601String(),
      'status': isDone ? 'SELESAI' : 'BERJALAN',
      'note': noteController.text,
      'is_done': isDone,
    });

    Navigator.pop(context);
  }
}
