import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quizzapp/widget/card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardScreen extends StatelessWidget {
  final int totalQuestions;
  final int rightAnswered;
  final int wrongAnswered;

  const DashboardScreen({
    required this.totalQuestions,
    required this.rightAnswered,
    required this.wrongAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(1.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Total Questions",
                    value: totalQuestions.toString(),
                    color: Colors.blue,
                  ),
                ),
                DashboardCard(
                  title: "Right Answer",
                  value: rightAnswered.toString(),
                  color: Colors.green,
                ),
                DashboardCard(
                  title: "Wrong Answer",
                  value: wrongAnswered.toString(),
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 20),
            // Pie Chart
            Expanded(
              child: rightAnswered == 0 && wrongAnswered == 0
                  ? Center(child: Text("No data available"))
                  : PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: rightAnswered.toDouble(),
                            title: "Right Answers",
                            radius: 10.w,
                            titleStyle: TextStyle(color: const Color.fromARGB(255, 20, 19, 19),fontWeight: FontWeight.w200, fontSize: 16.sp),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: wrongAnswered.toDouble(),
                            title: "Wrong Answers",
                            radius: 10.w,
                            titleStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

