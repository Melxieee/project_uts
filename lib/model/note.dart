class Note {
  int? id;
  String? title;
  String? date;
  String? note;

  Note({this.id, this.title, this.date, this.note});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }

    map['title'] = title;
    map['date'] = date;
    map['note'] = note;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    note = map['note'];
  }
}
