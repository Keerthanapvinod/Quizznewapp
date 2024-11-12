import 'package:quizzapp/models/choice.dart';

class Question {
  int? id;
  String questionText;
  List<Choice> choices;
  int answerChoicesID;

  Question({
    
    required this.questionText,
    required this.choices,
    required this.answerChoicesID, required id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'choices': choices.map((e) => e.toMap()).toList(),
      'correctAnswer': answerChoicesID,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
    
      id: map['id'],
      questionText: map['questionText'],
      choices: (map['choices'] as List).map((e) => Choice.fromMap(e)).toList(),
      answerChoicesID: map['correctAnswer'],
    );
  }
}