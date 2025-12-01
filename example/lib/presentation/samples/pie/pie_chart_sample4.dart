import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample4 extends StatefulWidget {
  const PieChartSample4({super.key});

  @override
  State<PieChartSample4> createState() => _PieChartSample4State();
}

class _PieChartSample4State extends State<PieChartSample4> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Column(
          children: [
            const Text(
              'Pie Chart with External Labels',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: showingSections(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;

      const colors = [
        Color(0xff0293ee),
        Color(0xfff8b250),
        Color(0xff845bef),
        Color(0xff13d38e),
        Color(0xffff6c6c),
      ];

      const values = [50.0, 20.0, 5.0, 20.0, 5.0];
      const titles = ['50%', '20%', '5%', '20%', '5%'];

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: titles[i],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        externalLabel: ExternalLabelConfig(
          enabled: true,
          labelDistance: 10,
          leaderLineLength: 25,
          leaderLineWidth: 2,
          horizontalLineLength: 20,
          leaderLineStyle: LeaderLineStyle.elbow,
        ),
        showTitle: true, // Hide internal title when using external label
      );
    });
  }
}
