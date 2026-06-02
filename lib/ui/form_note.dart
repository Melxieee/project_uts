import 'package:flutter/material.dart';
import 'package:project_uts/db/db_helper.dart';
import 'package:project_uts/model/note.dart';
import 'package:project_uts/utils/note_colors.dart';

class FormNote extends StatefulWidget {
  final Note? note;

  FormNote({this.note});

  @override
  _FormNoteState createState() => _FormNoteState();
}

class _FormNoteState extends State<FormNote> {
  DbHelper db = DbHelper();

  TextEditingController? title;
  TextEditingController? note;

  @override
  void initState() {
    // TODO: implement initState
    title = TextEditingController(
      text: widget.note == null ? '' : widget.note!.title,
    );
    note = TextEditingController(
      text: widget.note == null ? '' : widget.note!.note,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: NoteColors.ui,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
    );
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
          'Catatan',
          style: TextStyle(fontWeight: FontWeight.w600, color: NoteColors.ui),
        ),
        backgroundColor: NoteColors.background,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 5),
          TextField(
            controller: title,
            decoration: InputDecoration(
              hintText: 'Judul',
              filled: true,
              fillColor: NoteColors.white,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: NoteColors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: NoteColors.white),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: note,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Catat sesuatu...',
              filled: true,
              fillColor: NoteColors.white,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: NoteColors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: NoteColors.white),
              ),
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            child: (widget.note == null)
                ? Text(
                    'Simpan',
                    style: TextStyle(
                      color: NoteColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text(
                    'Update',
                    style: TextStyle(
                      color: NoteColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            style: style,
            onPressed: () {
              upsertNote();
            },
          ),
        ],
      ),
    );
  }

  Future<void> upsertNote() async {
    if (widget.note != null) {
      await db.updateNote(
        Note.fromMap({
          'id': widget.note!.id,
          'title': title!.text,
          'date': DateTime.now().toString(),
          'note': note!.text,
        }),
      );
      Navigator.pop(context, 'update');
    } else {
      await db.saveNote(
        Note(
          title: title!.text,
          date: DateTime.now().toString(),
          note: note!.text,
        ),
      );
      Navigator.pop(context, 'save');
    }
  }
}
