class Question {
  final String id;
  final String question;
  final String option0;
  final String option1;
  final String option2;
  final int answer; // 0, 1, or 2
  final String category;
  final bool hasImage;

  Question({
    required this.id,
    required this.question,
    required this.option0,
    required this.option1,
    required this.option2,
    required this.answer,
    required this.category,
    required this.hasImage,
  });

  factory Question.fromJson(Map<String, dynamic> json, String category) {
    final q = json['question'] as String;
    final bool isImage = q.endsWith('.png') || q.endsWith('.jpg');
    return Question(
      id: json['id'].toString(),
      question: q,
      option0: json['0'] as String,
      option1: json['1'] as String,
      option2: json['2'] as String,
      answer: int.parse(json['answer'].toString()),
      category: category,
      hasImage: isImage,
    );
  }

  List<String> get options => [option0, option1, option2];

  String get imagePath => hasImage ? 'assets/images/sign/$question' : '';
}
