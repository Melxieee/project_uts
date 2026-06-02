import 'package:flutter/material.dart';
import 'package:project_uts/model/note.dart';
import 'package:project_uts/utils/note_colors.dart';

class DetailNote extends StatelessWidget {
  final Note? note;

  DetailNote(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoteColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Catatan',
          style: TextStyle(fontWeight: FontWeight.w600, color: NoteColors.ui),
        ),
        backgroundColor: NoteColors.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NoteColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note!.title ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NoteColors.black,
                ),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: NoteColors.greyText,
                  ),
                  SizedBox(width: 6),
                  Text(
                    note!.date!.split(' ')[0],
                    style: TextStyle(fontSize: 12, color: NoteColors.greyText),
                  ),
                ],
              ),

              SizedBox(height: 15),

              Text(
                note!.note ?? '',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: NoteColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
