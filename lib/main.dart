import 'package:flutter/material.dart';
import 'package:project_uts/ui/list_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Catatan Harian',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: ListNotePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
