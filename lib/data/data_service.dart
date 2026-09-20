import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final Map<String, List<Question>> _cache = {};

  Future<List<Question>> loadCategory(String category) async {
    if (_cache.containsKey(category)) return _cache[category]!;
    final String data = await rootBundle.loadString('assets/data/$category.json');
    final List<dynamic> jsonList = json.decode(data);
    final questions = jsonList.map((j) => Question.fromJson(j as Map<String, dynamic>, category)).toList();
    _cache[category] = questions;
    return questions;
  }

  Future<Map<String, List<Question>>> loadAll() async {
    final categories = ['general', 'sign', 'priority', 'technique', 'emergency'];
    final result = <String, List<Question>>{};
    for (final cat in categories) {
      result[cat] = await loadCategory(cat);
    }
    return result;
  }
}
