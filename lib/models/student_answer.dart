class StudentAnswer {
  int? id;
  int? studentId;
  int? questionId;
  String answerChoice;

  StudentAnswer({
   
    required this.studentId,
    required this.questionId,
    required this.answerChoice, required id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'questionId': questionId,
      'answerChoice': answerChoice,
    };
  }

  factory StudentAnswer.fromMap(Map<String, dynamic> map) {
    return StudentAnswer(
      id: map['id'],
      studentId: map['studentId'],
      questionId: map['questionId'],
      answerChoice: map['answerChoice'],
    );
  }
}
