class Choice {
  int? id;
  int questionId;
  String choiceText;

  Choice({this.id, required this.questionId, required this.choiceText});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionId': questionId,
      'choiceText': choiceText,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      id: map['id'],
      questionId: map['questionId'],
      choiceText: map['choiceText'],
    );
  }
}

