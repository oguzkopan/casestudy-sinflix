import 'dart:convert';

import 'package:flutter/services.dart';

class Film {
  final String id;            // unique
  final String title;
  final String description;
  final String studio;
  final String imageUrl;

  Film({required this.id, required this.title, required this.description, required this.studio, required this.imageUrl});

  factory Film.fromJson(Map<String, dynamic> j) => Film(
    id: j['id'],
    title: j['title'],
    description: j['description'],
    studio: j['studio'],
    imageUrl: j['imageUrl'],
  );

  static Future<List<Film>> loadFromAsset() async {
    final jsonStr = await rootBundle.loadString('assets/data/films.json');
    final list = json.decode(jsonStr) as List;
    return list.map((e) => Film.fromJson(e)).toList();
  }
}
