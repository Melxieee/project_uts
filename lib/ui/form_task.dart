import 'package:flutter/material.dart';
import 'package:project_uts/model/task.dart';
import 'package:project_uts/utils/note_colors.dart';

class TaskFormSheet extends StatefulWidget {
  final Task? taskToEdit;

  const TaskFormSheet({super.key, this.taskToEdit});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  late TextEditingController nameController;
  DateTime? selectedReminder;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    selectedReminder = widget.taskToEdit?.reminder;

    // Position cursor at the end of text when editing
    if (widget.taskToEdit != null) {
      nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // Format date helper
  String formatDateTime(DateTime dateTime) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = months[dateTime.month - 1];
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day $month, $hour:$minute";
  }

  // Select reminder date & time helper
  Future<DateTime?> _selectReminder(DateTime? initial) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: NoteColors.ui,
              onPrimary: NoteColors.background,
              onSurface: NoteColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: NoteColors.ui),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return null;

    if (!mounted) return null;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: NoteColors.ui,
              onPrimary: Colors.white,
              onSurface: NoteColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: NoteColors.ui),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NoteColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.taskToEdit != null ? 'Edit Tugas' : 'Tugas Baru',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: NoteColors.ui,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            autofocus: true,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Nama Tugas',
              hintStyle: const TextStyle(color: Color(0xB29E9E9E)),
              filled: true,
              fillColor: NoteColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: NoteColors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              DateTime? picked = await _selectReminder(selectedReminder);
              if (picked != null) {
                setState(() {
                  selectedReminder = picked;
                });
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.alarm,
                    color: selectedReminder != null
                        ? NoteColors.ui
                        : NoteColors.greyText,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedReminder != null
                        ? 'Pengingat: ${formatDateTime(selectedReminder!)}'
                        : 'Tambahkan Pengingat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedReminder != null
                          ? NoteColors.ui
                          : NoteColors.greyText,
                    ),
                  ),
                  if (selectedReminder != null) ...[
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedReminder = null;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: NoteColors.greyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NoteColors.ui,
                  foregroundColor: NoteColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    Navigator.pop(context, {
                      'title': nameController.text.trim(),
                      'reminder': selectedReminder,
                    });
                  }
                },
                child: const Text(
                  'Selesai',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
