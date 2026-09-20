import 'package:get/get.dart';
import '../data/data_service.dart';
import '../models/question.dart';

class StudyController extends GetxController {
  final String category;
  StudyController(this.category);

  final _dataService = DataService();
  final questions = <Question>[].obs;
  final filtered = <Question>[].obs;
  final searchQuery = ''.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    debounce(searchQuery, (_) => _filter(), time: const Duration(milliseconds: 300));
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    questions.value = await _dataService.loadCategory(category);
    filtered.value = questions;
    isLoading.value = false;
  }

  void search(String q) {
    searchQuery.value = q;
  }

  void _filter() {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) {
      filtered.value = questions;
      return;
    }
    filtered.value = questions.where((item) {
      return item.question.toLowerCase().contains(q) ||
          item.option0.toLowerCase().contains(q) ||
          item.option1.toLowerCase().contains(q) ||
          item.option2.toLowerCase().contains(q);
    }).toList();
  }
}
