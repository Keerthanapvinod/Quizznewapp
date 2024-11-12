import 'package:quizzapp/models/choice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/questions.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE questions (
            id INTEGER PRIMARY KEY,
            questionText TEXT NOT NULL,
            answerChoicesID INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE choices (
            id INTEGER PRIMARY KEY,
            questionId INTEGER NOT NULL,
            choiceText TEXT NOT NULL,
            FOREIGN KEY (questionId) REFERENCES questions(id)
          )
        ''');
      },
    );
  }

  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('questions', {
      'id': question.id,
      'questionText': question.questionText,
      'answerChoicesID': question.answerChoicesID,
    });
  }

  Future<int> insertChoice(Choice choice) async {
    final db = await database;
    return await db.insert('choices', {
      'id': choice.questionId,
      'questionId': choice.questionId,
      'choiceText': choice.choiceText,
    });
  }

  Future<List<Question>> getQuestions() async {
    final db = await database;
    List<Map<String, dynamic>> questionMaps = await db.query('questions');
    List<Question> questions = [];

    for (var questionMap in questionMaps) {
      int questionId = questionMap['id'];
      List<Map<String, dynamic>> choiceMaps =
          await db.query('choices', where: 'questionId = ?', whereArgs: [questionId]);

      List<Choice> choices = choiceMaps.map((choiceMap) {
        return Choice(
          questionId: choiceMap['questionId'],
          choiceText: choiceMap['choiceText'],
        );
      }).toList();

      questions.add(Question(
        id: questionMap['id'],
        questionText: questionMap['questionText'],
        choices: choices,
        answerChoicesID: questionMap['answerChoicesID'],
      ));
    }

    return questions;
  }
}
