import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_boxes/models/category.dart';

class ListCategories extends StatefulWidget {
  static const routeName = '/category';
  const ListCategories({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  final _text = TextEditingController();
  Box<Category>? _categoryBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  void _initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CategoryAdapter());
    }

    Hive.openBox<Category>('category').then((value) {
      setState(() {
        _categoryBox = value;
      });
    });
  }

  void _addRecord(String name) async {
    _categoryBox?.add(Category(name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _categoryBox == null
            ? const CircularProgressIndicator()
            : ValueListenableBuilder(
                valueListenable: _categoryBox!.listenable(),
                builder: (context, Box<Category> box, widget) {
                  return ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: ((context, index) {
                      final category = box.values.elementAt(index);
                      return ElevatedButton(
                        child: Text(category.name),
                        onPressed: () => Navigator.pushNamed(context, '/note', arguments: category.name),
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
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(10),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _text,
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Add'),
                          onPressed: () {
                            _addRecord(_text.text);
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
