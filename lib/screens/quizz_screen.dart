import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:quizzapp/dashbord.dart';
import 'package:quizzapp/data/questions_list.dart';
import 'package:quizzapp/models/questions.dart';
import 'package:quizzapp/utilts/database_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class QuizzScreen extends StatefulWidget {
  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  int _selectedIndex = 0;
  List<int?> _selectedOptions = [];
  PageController _pageController = PageController();
  Timer? _timer;
  int _timeLeft = 30;
  
  
  List<Question> questions = [];
  
  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  Future<void> _loadQuestions() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    
    
    List<Question> fetchedQuestions = await dbHelper.getQuestions();
    
   
    setState(() {
      questions = fetchedQuestions;
      _selectedOptions = List.filled(questions.length, null); 
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (_pageController.page!.toInt() < questions.length - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  int get _answeredQuestions {
    return _selectedOptions.where((option) => option != null).length;
  }

  int get _unansweredQuestions {
    return _selectedOptions.where((option) => option == null).length;
  }

  int get _rightAnswered {
    int rightCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_selectedOptions[i] != null && _selectedOptions[i] == questions[i].answerChoicesID) {
        rightCount++;
      }
    }
    return rightCount;
  }

  int get _wrongAnswered {
    return _answeredQuestions - _rightAnswered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator()) 
          : IndexedStack(
              index: _selectedIndex,
              children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: questions.length,
                  onPageChanged: (index) {
                    if (_selectedIndex == 0) {
                      _startTimer(); // Reset timer only on quiz page
                    }
                  },
                  itemBuilder: (context, index) {
                    final question = questions[index];

                    if (question.choices.isNotEmpty) {
                      return StickyHeader(
                        header: Container(
                          height: 10.h,
                          width: 100.w,
                          color: Colors.blue,
                          padding: EdgeInsets.all(1.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time left: $_timeLeft seconds',
                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              ),
                              Text(
                                question.questionText,
                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        content: Column(
                          children: [
                            // Render choices dynamically
                            ...List<Widget>.generate(
                              question.choices.length,
                              (optIndex) => RadioListTile(
                                title: Text(question.choices[optIndex].choiceText, style: TextStyle(fontSize: 18.sp)),
                                value: optIndex,
                                groupValue: _selectedOptions[index],
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedOptions[index] = value; // Update selected option
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _nextQuestion,
                              child: Text('Next', style: TextStyle(fontSize: 17.sp)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No choices available for this question.',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      );
                    }
                  },
                ),
                DashboardScreen(
                  totalQuestions: questions.length,
                  rightAnswered: _rightAnswered,
                  wrongAnswered: _wrongAnswered,
                ),
              ],
            ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.quiz_outlined, size: 25.px),
          Icon(Icons.dashboard, size: 25.px),
        ],
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            _startTimer(); // Start timer if navigating back to quiz
          } else {
            _timer?.cancel(); // Cancel timer if switching to dashboard
          }
        },
      ),
    );
  }
}
