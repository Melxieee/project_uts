import 'package:flutter/material.dart';
import 'package:project_uts/db/db_helper.dart';
import 'package:project_uts/model/note.dart';
import 'package:project_uts/ui/detail_note.dart';
import 'package:project_uts/utils/note_colors.dart';

import 'form_note.dart';
import 'package:project_uts/ui/list_task.dart';

class ListNotePage extends StatefulWidget {
  const ListNotePage({super.key});

  @override
  State<ListNotePage> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNotePage> {
  List<Note> listNote = [];
  List<Note> listSearch = [];

  TextEditingController searchController = TextEditingController();

  DbHelper db = DbHelper();
  // navbar
  int _selectedNavbar = 0;
  int _activeTab = 0;

  void _changeSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
      _activeTab = index;
    });
  }

  @override
  void initState() {
    _getAllNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoteColors.background,
      appBar: AppBar(backgroundColor: NoteColors.background, toolbarHeight: 0),
      body: IndexedStack(
        index: _activeTab,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: NoteColors.black,
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            listSearch = listNote.where((note) {
                              return note.title!.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ) ||
                                  note.note!.toLowerCase().contains(
                                    value.toLowerCase(),
                                  );
                            }).toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          prefixIcon: Icon(Icons.search),

                          filled: true,
                          fillColor: NoteColors.white,

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: NoteColors.white),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: NoteColors.white),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: NoteColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  // itemCount: listNote.length,
                  itemCount: searchController.text.isEmpty
                      ? listNote.length
                      : listSearch.length,
                  itemBuilder: (context, index) {
                    // Note note = listNote[index];
                    Note note = searchController.text.isEmpty
                        ? listNote[index]
                        : listSearch[index];

                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailNote(note),
                          ),
                        ),
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: NoteColors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${note.title}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: NoteColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 5),
                            Text(
                              '${note.note}',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1,
                                color: NoteColors.greyText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 8,
                                  color: NoteColors.greyText,
                                ),

                                SizedBox(width: 5),

                                Text(
                                  '${note.date}'.split(' ')[0],
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: NoteColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // tombol edit
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .end, // Membawa tombol ke sisi kanan
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _openFormEdit(note);
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: NoteColors.ui, //
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 10,
                                              color: NoteColors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Edit',
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
                                Spacer(),
                                // tombol hapus
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end, // tombol ke kanan
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        AlertDialog hapus = AlertDialog(
                                          title: const Text('Information'),
                                          content: SizedBox(
                                            height: 60,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Apakah anda yakin ingin menghapus catatan dengan judul "${note.title}"?',
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Ya'),
                                              onPressed: () {
                                                _deleteNote(note, index); //
                                                Navigator.pop(
                                                  context,
                                                ); // Tutup dialog
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

                                        //Muncul dialognya
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const TugasPage(),
        ],
      ),

      bottomNavigationBar: SizedBox(
        height: 80, //
        child: BottomNavigationBar(
          backgroundColor: NoteColors.white,
          selectedItemColor: NoteColors.ui,
          unselectedItemColor: NoteColors.greyText,
          currentIndex: _selectedNavbar,
          onTap: _changeSelectedNavbar,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment, size: 18),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt, size: 18),
              label: 'Tugas',
            ),
          ],
        ),
      ),
      floatingActionButton: _activeTab == 0
          ? FloatingActionButton(
              onPressed: () => _openFormCreate(),
              backgroundColor: NoteColors.ui,
              elevation: 2,
              child: const Icon(Icons.add, color: NoteColors.white, size: 28),
            )
          : null,
    );
  }

  Future<void> _getAllNote() async {
    var list = await db.getAllNote();

    setState(() {
      listNote.clear();
      list!.forEach((note) {
        listNote.add(Note.fromMap(note));
      });
    });
  }

  Future<void> _deleteNote(Note note, int position) async {
    await db.deleteNote(note.id!);

    setState(() {
      listNote.removeAt(position);
    });
  }

  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormNote()),
    );

    if (result == 'save') {
      await _getAllNote();
    }
  }

  Future<void> _openFormEdit(Note note) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormNote(note: note)),
    );

    if (result == 'update') {
      await _getAllNote();
    }
  }
}
