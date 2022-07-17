import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_boxes/models/note.dart';

class ListNotes extends StatefulWidget {
  static const routeName = '/note';
  const ListNotes({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<ListNotes> createState() => _ListNotesState();
}

class _ListNotesState extends State<ListNotes> {
  final _textName = TextEditingController();
  final _textDescription = TextEditingController();
  Box<Note>? _noteBox;
  late String category = widget.category;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  void _initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NoteAdapter());
    }

    Hive.openBox<Note>(widget.category).then((value) {
      setState(() {
        _noteBox = value;
      });
    });
  }

  void _addRecord(String name, String description) async {
    _noteBox?.add(Note(name, description));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Center(
        child: _noteBox == null
            ? const CircularProgressIndicator()
            : ValueListenableBuilder(
                valueListenable: _noteBox!.listenable(),
                builder: (context, Box<Note> box, widget) {
                  return ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: ((context, index) {
                      final note = box.values.elementAt(index);
                      return ElevatedButton(
                        child: Text(note.name),
                        onPressed: () => Navigator.pushNamed(context, '/article', arguments: [category, note.name, note.description]),
                      );
                    }),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Name'),
                        TextField(
                          controller: _textName,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text('Description'),
                        TextField(
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                          ),
                          controller: _textDescription,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          child: const Text('Add'),
                          onPressed: () {
                            _addRecord(_textName.text, _textDescription.text);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
