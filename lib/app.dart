import 'package:flutter/material.dart';
import 'package:hive_boxes/article.dart';
import 'package:hive_boxes/list_notes.dart';

import 'list_categories.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Boxes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ListCategories.routeName:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return const ListCategories(title: 'List Categories');
              },
            );
          case ListNotes.routeName:
            final args = settings.arguments.toString();
            return MaterialPageRoute(builder: (BuildContext context) {
              return ListNotes(
                category: args,
              );
            });
          case Article.routeName:
            final args = settings.arguments as List<String>;
            return MaterialPageRoute(builder: (BuildContext context) {
              return Article(
                title: args[0],
                name: args[1],
                description: args[2],
              );
            });
          default:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return const ListCategories(title: 'List Categories');
              },
            );
        }
      },
      home: const ListCategories(title: 'Hive Boxes'),
    );
  }
}
