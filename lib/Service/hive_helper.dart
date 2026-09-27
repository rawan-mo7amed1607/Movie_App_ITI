import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_counter_app/Model/note.dart';

class HiveHelper {
  static const String boxName = 'notes';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(boxName);
  }

  Box<Note> get box => Hive.box<Note>(boxName);

  List<Note> getNotes() {
    return box.values.toList();
  }

  Future<void> addNote(Note note) async {
    await box.add(note);
  }

  Future<void> deleteNote(int index) async {
    await box.deleteAt(index);
  }
}