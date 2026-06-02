import 'package:flutter/material.dart';
import 'package:project_uts/model/task.dart';
import 'package:project_uts/utils/note_colors.dart';
import 'package:project_uts/ui/task_form_sheet.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  // Local list of tasks
  final List<Task> tasks = [];

  // Format date helper
  String formatDateTime(DateTime dateTime) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = months[dateTime.month - 1];
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day $month, $hour:$minute";
  }

  // Open "Tugas Baru" or "Edit Tugas" bottom sheet
  void _showTaskForm(BuildContext context, {Task? taskToEdit}) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => TaskFormSheet(taskToEdit: taskToEdit),
    );

    if (result != null && mounted) {
      setState(() {
        if (taskToEdit != null) {
          taskToEdit.title = result['title'];
          taskToEdit.reminder = result['reminder'];
        } else {
          tasks.add(Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: result['title'],
            reminder: result['reminder'],
          ));
        }
      });
    }
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NoteColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checklist button
          GestureDetector(
            onTap: () {
              setState(() {
                task.isCompleted = !task.isCompleted;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              child: Icon(
                task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: task.isCompleted ? NoteColors.greyText : NoteColors.ui,
                size: 24,
              ),
            ),
          ),
          // Task Title & Reminder
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showTaskForm(context, taskToEdit: task),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? NoteColors.greyText : NoteColors.black,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (task.reminder != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 12,
                          color: NoteColors.greyText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatDateTime(task.reminder!),
                          style: const TextStyle(
                            fontSize: 11,
                            color: NoteColors.greyText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Delete button
          InkWell(
            onTap: () {
              AlertDialog hapus = AlertDialog(
                title: const Text('Information'),
                content: SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apakah anda yakin ingin menghapus tugas dengan judul "${task.title}"?',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Ya'),
                    onPressed: () {
                      setState(() {
                        tasks.removeWhere((t) => t.id == task.id);
                      });
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('Tidak'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );

              showDialog(
                context: context,
                builder: (context) => hapus,
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: NoteColors.ui,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 10,
                    color: NoteColors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: NoteColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    List<Task> activeTasks = tasks.where((t) => !t.isCompleted).toList();
    List<Task> completedTasks = tasks.where((t) => t.isCompleted).toList();

    if (activeTasks.isEmpty && completedTasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Color(0x4D9E9E9E),
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada tugas',
              style: TextStyle(
                fontSize: 16,
                color: NoteColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        if (activeTasks.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...activeTasks.map((task) => _buildTaskItem(task)),
        ],
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
            child: Text(
              'Selesai',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: NoteColors.black,
              ),
            ),
          ),
          ...completedTasks.map((task) => _buildTaskItem(task)),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoteColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Tugas',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: NoteColors.black,
                ),
              ),
            ),
            // Task List
            Expanded(
              child: _buildTaskList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(context),
        backgroundColor: NoteColors.ui,
        elevation: 2,
        child: const Icon(
          Icons.add,
          color: NoteColors.white,
          size: 28,
        ),
      ),
    );
  }
}
