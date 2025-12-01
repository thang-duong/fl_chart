import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('PieChart data equality check', () {
    test('PieChartData equality test', () {
      expect(pieChartData1 == pieChartData1Clone, true);

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: false,
                border: Border.all(),
              ),
            ),
        true,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: true,
                border: Border.all(),
              ),
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              startDegreeOffset: 33,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            PieChartData(
              borderData: FlBorderData(
                show: false,
                border: Border.all(),
              ),
              startDegreeOffset: 0,
              centerSpaceColor: Colors.white,
              centerSpaceRadius: 12,
              pieTouchData: PieTouchData(
                enabled: false,
              ),
              sectionsSpace: 44,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [],
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [
                PieChartSectionData(value: 12, color: Colors.red),
                PieChartSectionData(value: 22, color: Colors.green),
              ],
            ),
        true,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [
                PieChartSectionData(value: 12, color: Colors.red),
                PieChartSectionData(
                  value: 22,
                  color: Colors.green.withValues(alpha: 0.99),
                ),
              ],
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [
                PieChartSectionData(value: 22, color: Colors.green),
                PieChartSectionData(value: 12, color: Colors.red),
              ],
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              centerSpaceColor: Colors.cyan,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              centerSpaceRadius: 44,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              pieTouchData: PieTouchData(),
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sectionsSpace: 44.000001,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              titleSunbeamLayout: true,
            ),
        false,
      );
    });

    test('ExternalLabelConfig equality test', () {
      const config1 = ExternalLabelConfig(
        enabled: true,
      );

      const config1Clone = ExternalLabelConfig(
        enabled: true,
      );

      expect(config1 == config1Clone, true);

      expect(
        config1 ==
            config1Clone.copyWith(
              enabled: false,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              labelDistance: 40,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              leaderLineColor: Colors.red,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              leaderLineWidth: 2,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              leaderLineLength: 30,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              leaderLineStyle: LeaderLineStyle.straight,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              horizontalLineLength: 20,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              curveControlPoint1: 0.6,
            ),
        false,
      );

      expect(
        config1 ==
            config1Clone.copyWith(
              curveControlPoint2: 0.4,
            ),
        false,
      );
    });

    test('ExternalLabelConfig default values test', () {
      const config = ExternalLabelConfig();

      expect(config.enabled, false);
      expect(config.labelDistance, 30);
      expect(config.leaderLineColor, null);
      expect(config.leaderLineWidth, 1);
      expect(config.leaderLineLength, 20);
      expect(config.leaderLineStyle, LeaderLineStyle.elbow);
      expect(config.horizontalLineLength, 15);
      expect(config.curveControlPoint1, 0.5);
      expect(config.curveControlPoint2, 0.3);
    });

    test('ExternalLabelConfig lerp test', () {
      const config1 = ExternalLabelConfig(
        enabled: true,
        leaderLineColor: Colors.red,
      );

      const config2 = ExternalLabelConfig(
        labelDistance: 40,
        leaderLineColor: Colors.blue,
        leaderLineWidth: 2,
        leaderLineLength: 30,
        leaderLineStyle: LeaderLineStyle.straight,
        horizontalLineLength: 20,
        curveControlPoint1: 0.7,
      );

      final lerped = ExternalLabelConfig.lerp(config1, config2, 0.5);

      expect(lerped.enabled, false); // Uses config2's boolean value
      expect(lerped.labelDistance, 35);
      expect((lerped.leaderLineColor!.a * 255).round(), 255);
      expect((lerped.leaderLineColor!.r * 255).round(), closeTo(139, 1));
      expect((lerped.leaderLineColor!.g * 255).round(), closeTo(108, 1));
      expect((lerped.leaderLineColor!.b * 255).round(), closeTo(148, 1));
      expect(lerped.leaderLineWidth, 1.5);
      expect(lerped.leaderLineLength, 25);
      expect(
        lerped.leaderLineStyle,
        LeaderLineStyle.straight,
      ); // Uses config2's enum value
      expect(lerped.horizontalLineLength, 17.5);
      expect(lerped.curveControlPoint1, 0.6);
      expect(lerped.curveControlPoint2, 0.3);
    });

    test('PieChartSectionData with externalLabel equality test', () {
      final section1 = PieChartSectionData(
        value: 10,
        color: Colors.red,
        externalLabel: const ExternalLabelConfig(
          enabled: true,
        ),
      );

      final section1Clone = PieChartSectionData(
        value: 10,
        color: Colors.red,
        externalLabel: const ExternalLabelConfig(
          enabled: true,
        ),
      );

      expect(section1 == section1Clone, true);

      expect(
        section1 ==
            section1Clone.copyWith(
              externalLabel: const ExternalLabelConfig(),
            ),
        false,
      );

      expect(
        section1 ==
            section1Clone.copyWith(
              externalLabel: const ExternalLabelConfig(
                enabled: true,
                labelDistance: 40,
              ),
            ),
        false,
      );
    });

    test('PieChartSectionData lerp with externalLabel test', () {
      final section1 = PieChartSectionData(
        value: 10,
        color: Colors.red,
        radius: 50,
        externalLabel: const ExternalLabelConfig(
          enabled: true,
        ),
      );

      final section2 = PieChartSectionData(
        value: 20,
        color: Colors.blue,
        radius: 60,
        externalLabel: const ExternalLabelConfig(
          labelDistance: 40,
          leaderLineWidth: 2,
          leaderLineLength: 30,
        ),
      );

      final lerped = PieChartSectionData.lerp(section1, section2, 0.5);

      expect(lerped.value, 15);
      expect((lerped.color.a * 255).round(), 255);
      expect((lerped.color.r * 255).round(), closeTo(139, 1));
      expect((lerped.color.g * 255).round(), closeTo(108, 1));
      expect((lerped.color.b * 255).round(), closeTo(148, 1));
      expect(lerped.radius, 55);
      expect(lerped.externalLabel.enabled, false);
      expect(lerped.externalLabel.labelDistance, 35);
      expect(lerped.externalLabel.leaderLineWidth, 1.5);
      expect(lerped.externalLabel.leaderLineLength, 25);
    });

    test('PieTouchData equality test', () {
      final sample1 = PieTouchData(
        touchCallback: (event, response) {},
        enabled: true,
      );
      final sample2 = PieTouchData(
        enabled: true,
      );

      expect(sample1 == sample2, false);

      final disabled = PieTouchData(
        enabled: false,
      );
      expect(sample1 == disabled, false);

      final zeroLongPressDuration = PieTouchData(
        enabled: true,
        longPressDuration: Duration.zero,
      );
      expect(sample1 == zeroLongPressDuration, false);
    });
  });
}
