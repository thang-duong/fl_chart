// coverage:ignore-file
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// [PieChart] needs this class to render itself.
///
/// It holds data needed to draw a pie chart,
/// including pie sections, colors, ...
class PieChartData extends BaseChartData with EquatableMixin {
  /// [PieChart] draws some [sections] in a circle,
  /// and applies free space with radius [centerSpaceRadius],
  /// and color [centerSpaceColor] in the center of the circle,
  /// if you don't want it, set [centerSpaceRadius] to zero.
  ///
  /// It draws [sections] from zero degree (right side of the circle) clockwise,
  /// you can change the starting point, by changing [startDegreeOffset] (in degrees).
  ///
  /// You can define a gap between [sections] by setting [sectionsSpace].
  ///
  /// You can modify [pieTouchData] to customize touch behaviors and responses.
  PieChartData({
    List<PieChartSectionData>? sections,
    double? centerSpaceRadius,
    Color? centerSpaceColor,
    double? sectionsSpace,
    double? startDegreeOffset,
    PieTouchData? pieTouchData,
    FlBorderData? borderData,
    bool? titleSunbeamLayout,
  })  : sections = sections ?? const [],
        centerSpaceRadius = centerSpaceRadius ?? double.infinity,
        centerSpaceColor = centerSpaceColor ?? Colors.transparent,
        sectionsSpace = sectionsSpace ?? 2,
        startDegreeOffset = startDegreeOffset ?? 0,
        pieTouchData = pieTouchData ?? PieTouchData(),
        titleSunbeamLayout = titleSunbeamLayout ?? false,
        super(
          borderData: borderData ?? FlBorderData(show: false),
        );

  /// Defines showing sections of the [PieChart].
  final List<PieChartSectionData> sections;

  /// Radius of free space in center of the circle.
  final double centerSpaceRadius;

  /// Color of free space in center of the circle.
  final Color centerSpaceColor;

  /// Defines gap between sections.
  ///
  /// Does not work on html-renderer,
  /// https://github.com/imaNNeo/fl_chart/issues/955
  final double sectionsSpace;

  /// [PieChart] draws [sections] from zero degree (right side of the circle) clockwise.
  final double startDegreeOffset;

  /// Handles touch behaviors and responses.
  final PieTouchData pieTouchData;

  /// Whether to rotate the titles on each section of the chart
  final bool titleSunbeamLayout;

  /// We hold this value to determine weight of each [PieChartSectionData.value].
  double get sumValue => sections
      .map((data) => data.value)
      .reduce((first, second) => first + second);

  /// Copies current [PieChartData] to a new [PieChartData],
  /// and replaces provided values.
  PieChartData copyWith({
    List<PieChartSectionData>? sections,
    double? centerSpaceRadius,
    Color? centerSpaceColor,
    double? sectionsSpace,
    double? startDegreeOffset,
    PieTouchData? pieTouchData,
    FlBorderData? borderData,
    bool? titleSunbeamLayout,
  }) =>
      PieChartData(
        sections: sections ?? this.sections,
        centerSpaceRadius: centerSpaceRadius ?? this.centerSpaceRadius,
        centerSpaceColor: centerSpaceColor ?? this.centerSpaceColor,
        sectionsSpace: sectionsSpace ?? this.sectionsSpace,
        startDegreeOffset: startDegreeOffset ?? this.startDegreeOffset,
        pieTouchData: pieTouchData ?? this.pieTouchData,
        borderData: borderData ?? this.borderData,
        titleSunbeamLayout: titleSunbeamLayout ?? this.titleSunbeamLayout,
      );

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  PieChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is PieChartData && b is PieChartData) {
      return PieChartData(
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        centerSpaceColor: Color.lerp(a.centerSpaceColor, b.centerSpaceColor, t),
        centerSpaceRadius: lerpDoubleAllowInfinity(
          a.centerSpaceRadius,
          b.centerSpaceRadius,
          t,
        ),
        pieTouchData: b.pieTouchData,
        sectionsSpace: lerpDouble(a.sectionsSpace, b.sectionsSpace, t),
        startDegreeOffset:
            lerpDouble(a.startDegreeOffset, b.startDegreeOffset, t),
        sections: lerpPieChartSectionDataList(a.sections, b.sections, t),
        titleSunbeamLayout: b.titleSunbeamLayout,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        sections,
        centerSpaceRadius,
        centerSpaceColor,
        pieTouchData,
        sectionsSpace,
        startDegreeOffset,
        borderData,
        titleSunbeamLayout,
      ];
}

/// Configuration for external labels with leader lines
class ExternalLabelConfig with EquatableMixin {
  /// Creates an external label configuration
  const ExternalLabelConfig({
    this.enabled = false,
    this.labelDistance = 30.0,
    this.leaderLineColor,
    this.leaderLineWidth = 1.0,
    this.leaderLineLength = 20.0,
    this.leaderLineStyle = LeaderLineStyle.elbow,
    this.horizontalLineLength = 15.0,
    this.curveControlPoint1 = 0.5,
    this.curveControlPoint2 = 0.3,
  });

  /// Whether to show external label with leader line
  final bool enabled;

  /// Distance from pie edge to label
  final double labelDistance;

  /// Color of the leader line (defaults to section color if null)
  final Color? leaderLineColor;

  /// Width of the leader line
  final double leaderLineWidth;

  /// Length of the leader line
  final double leaderLineLength;

  /// Style of the leader line
  final LeaderLineStyle leaderLineStyle;

  /// Length of the horizontal line segment (used with elbow style)
  final double horizontalLineLength;

  /// Control point 1 for curved line (multiplier of leaderLineLength)
  /// Used to calculate the first control point position
  final double curveControlPoint1;

  /// Control point 2 for curved line (multiplier of leaderLineLength)
  /// Used to calculate the second control point position
  final double curveControlPoint2;

  /// Copies current [ExternalLabelConfig] to a new [ExternalLabelConfig]
  ExternalLabelConfig copyWith({
    bool? enabled,
    double? labelDistance,
    Color? leaderLineColor,
    double? leaderLineWidth,
    double? leaderLineLength,
    LeaderLineStyle? leaderLineStyle,
    double? horizontalLineLength,
    double? curveControlPoint1,
    double? curveControlPoint2,
  }) =>
      ExternalLabelConfig(
        enabled: enabled ?? this.enabled,
        labelDistance: labelDistance ?? this.labelDistance,
        leaderLineColor: leaderLineColor ?? this.leaderLineColor,
        leaderLineWidth: leaderLineWidth ?? this.leaderLineWidth,
        leaderLineLength: leaderLineLength ?? this.leaderLineLength,
        leaderLineStyle: leaderLineStyle ?? this.leaderLineStyle,
        horizontalLineLength: horizontalLineLength ?? this.horizontalLineLength,
        curveControlPoint1: curveControlPoint1 ?? this.curveControlPoint1,
        curveControlPoint2: curveControlPoint2 ?? this.curveControlPoint2,
      );

  /// Lerps between two [ExternalLabelConfig] based on [t]
  static ExternalLabelConfig lerp(
    ExternalLabelConfig a,
    ExternalLabelConfig b,
    double t,
  ) =>
      ExternalLabelConfig(
        enabled: b.enabled,
        labelDistance: lerpDouble(a.labelDistance, b.labelDistance, t) ?? 30.0,
        leaderLineColor: Color.lerp(a.leaderLineColor, b.leaderLineColor, t),
        leaderLineWidth:
            lerpDouble(a.leaderLineWidth, b.leaderLineWidth, t) ?? 1.0,
        leaderLineLength:
            lerpDouble(a.leaderLineLength, b.leaderLineLength, t) ?? 20.0,
        leaderLineStyle: b.leaderLineStyle,
        horizontalLineLength:
            lerpDouble(a.horizontalLineLength, b.horizontalLineLength, t) ??
                15.0,
        curveControlPoint1:
            lerpDouble(a.curveControlPoint1, b.curveControlPoint1, t) ?? 0.5,
        curveControlPoint2:
            lerpDouble(a.curveControlPoint2, b.curveControlPoint2, t) ?? 0.3,
      );

  @override
  List<Object?> get props => [
        enabled,
        labelDistance,
        leaderLineColor,
        leaderLineWidth,
        leaderLineLength,
        leaderLineStyle,
        horizontalLineLength,
        curveControlPoint1,
        curveControlPoint2,
      ];
}

/// Style options for leader lines
enum LeaderLineStyle {
  /// Straight line from pie edge to label
  straight,

  /// Curved line from pie edge to label
  curved,

  /// Line with horizontal segment at the end (like in the example image)
  elbow,
}

/// Holds data related to drawing each [PieChart] section.
class PieChartSectionData with EquatableMixin {
  /// [PieChart] draws section from right side of the circle (0 degrees),
  /// each section have a [value] that determines how much it should occupy,
  /// this is depends on sum of all sections, each section should
  /// occupy ([value] / sumValues) * 360 degrees.
  ///
  /// It draws this section with filled [color], and [radius].
  ///
  /// If [showTitle] is true, it draws a title at the middle of section,
  /// you can set the text using [title], and set the style using [titleStyle],
  /// by default it draws texts at the middle of section, but you can change the
  /// [titlePositionPercentageOffset] to have your desire design,
  /// it should be between 0.0 to 1.0,
  /// 0.0 means near the center,
  /// 1.0 means near the outside of the [PieChart].
  ///
  /// If [badgeWidget] is not null, it draws a widget at the middle of section,
  /// by default it draws the widget at the middle of section, but you can change the
  /// [badgePositionPercentageOffset] to have your desire design,
  /// the value works the same way as [titlePositionPercentageOffset].
  ///
  /// If [externalLabel] is configured with enabled=true, it draws the label
  /// outside the pie chart with a leader line pointing to the section.
  PieChartSectionData({
    double? value,
    Color? color,
    this.gradient,
    double? radius,
    bool? showTitle,
    this.titleStyle,
    String? title,
    BorderSide? borderSide,
    this.badgeWidget,
    double? titlePositionPercentageOffset,
    double? badgePositionPercentageOffset,
    ExternalLabelConfig? externalLabel,
  })  : value = value ?? 10,
        color = color ?? Colors.cyan,
        radius = radius ?? 40,
        showTitle = showTitle ?? true,
        title = title ?? (value == null ? '' : value.toString()),
        borderSide = borderSide ?? const BorderSide(width: 0),
        titlePositionPercentageOffset = titlePositionPercentageOffset ?? 0.5,
        badgePositionPercentageOffset = badgePositionPercentageOffset ?? 0.5,
        externalLabel = externalLabel ?? const ExternalLabelConfig();

  /// It determines how much space it should occupy around the circle.
  ///
  /// This is depends on sum of all sections, each section should
  /// occupy ([value] / sumValues) * 360 degrees.
  ///
  /// value can not be null.
  final double value;

  /// Defines the color of section.
  final Color color;

  /// Defines the gradient of section. If specified, overrides the color setting.
  final Gradient? gradient;

  /// Defines the radius of section.
  final double radius;

  /// Defines show or hide the title of section.
  final bool showTitle;

  /// Defines style of showing title of section.
  final TextStyle? titleStyle;

  /// Defines text of showing title at the middle of section.
  final String title;

  /// Defines border stroke around the section
  final BorderSide borderSide;

  /// Defines a widget that represents the section.
  ///
  /// This can be anything from a text, an image, an animation, and even a combination of widgets.
  /// Use AnimatedWidgets to animate this widget.
  final Widget? badgeWidget;

  /// Defines position of showing title in the section.
  ///
  /// It should be between 0.0 to 1.0,
  /// 0.0 means near the center,
  /// 1.0 means near the outside of the [PieChart].
  final double titlePositionPercentageOffset;

  /// Defines position of badge widget in the section.
  ///
  /// It should be between 0.0 to 1.0,
  /// 0.0 means near the center,
  /// 1.0 means near the outside of the [PieChart].
  final double badgePositionPercentageOffset;

  /// Configuration for external label with leader line
  final ExternalLabelConfig externalLabel;

  /// Copies current [PieChartSectionData] to a new [PieChartSectionData],
  /// and replaces provided values.
  PieChartSectionData copyWith({
    double? value,
    Color? color,
    Gradient? gradient,
    double? radius,
    bool? showTitle,
    TextStyle? titleStyle,
    String? title,
    BorderSide? borderSide,
    Widget? badgeWidget,
    double? titlePositionPercentageOffset,
    double? badgePositionPercentageOffset,
    ExternalLabelConfig? externalLabel,
  }) =>
      PieChartSectionData(
        value: value ?? this.value,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        radius: radius ?? this.radius,
        showTitle: showTitle ?? this.showTitle,
        titleStyle: titleStyle ?? this.titleStyle,
        title: title ?? this.title,
        borderSide: borderSide ?? this.borderSide,
        badgeWidget: badgeWidget ?? this.badgeWidget,
        titlePositionPercentageOffset:
            titlePositionPercentageOffset ?? this.titlePositionPercentageOffset,
        badgePositionPercentageOffset:
            badgePositionPercentageOffset ?? this.badgePositionPercentageOffset,
        externalLabel: externalLabel ?? this.externalLabel,
      );

  /// Lerps a [PieChartSectionData] based on [t] value, check [Tween.lerp].
  static PieChartSectionData lerp(
    PieChartSectionData a,
    PieChartSectionData b,
    double t,
  ) =>
      PieChartSectionData(
        value: lerpDouble(a.value, b.value, t),
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
        radius: lerpDouble(a.radius, b.radius, t),
        showTitle: b.showTitle,
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
        title: b.title,
        borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
        badgeWidget: b.badgeWidget,
        titlePositionPercentageOffset: lerpDouble(
          a.titlePositionPercentageOffset,
          b.titlePositionPercentageOffset,
          t,
        ),
        badgePositionPercentageOffset: lerpDouble(
          a.badgePositionPercentageOffset,
          b.badgePositionPercentageOffset,
          t,
        ),
        externalLabel: ExternalLabelConfig.lerp(
          a.externalLabel,
          b.externalLabel,
          t,
        ),
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        value,
        color,
        gradient,
        radius,
        showTitle,
        titleStyle,
        title,
        borderSide,
        badgeWidget,
        titlePositionPercentageOffset,
        badgePositionPercentageOffset,
        externalLabel,
      ];
}

/// Holds data to handle touch events, and touch responses in the [PieChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart's renderer captures the touch events, and passes the pointerEvent
/// to the painter, and gets touched spot, and wraps it into a concrete [PieTouchResponse].
class PieTouchData extends FlTouchData<PieTouchResponse> with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// [touchCallback] notifies you about the happened touch/pointer events.
  /// It gives you a [FlTouchEvent] which is the happened event such as [FlPointerHoverEvent], [FlTapUpEvent], ...
  /// It also gives you a [PieTouchResponse] which contains information
  /// about the elements that has touched.
  ///
  /// Using [mouseCursorResolver] you can change the mouse cursor
  /// based on the provided [FlTouchEvent] and [PieTouchResponse]
  PieTouchData({
    bool? enabled,
    BaseTouchCallback<PieTouchResponse>? touchCallback,
    MouseCursorResolver<PieTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
  }) : super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
      ];
}

class PieTouchedSection with EquatableMixin {
  /// This class Contains [touchedSection], [touchedSectionIndex] that tells
  /// you touch happened on which section,
  /// [touchAngle] gives you angle of touch,
  /// and [touchRadius] gives you radius of the touch.
  PieTouchedSection(
    this.touchedSection,
    this.touchedSectionIndex,
    this.touchAngle,
    this.touchRadius,
  );

  /// touch happened on this section
  final PieChartSectionData? touchedSection;

  /// touch happened on this position
  final int touchedSectionIndex;

  /// touch happened with this angle on the [PieChart]
  final double touchAngle;

  /// touch happened with this radius on the [PieChart]
  final double touchRadius;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        touchedSection,
        touchedSectionIndex,
        touchAngle,
        touchRadius,
      ];
}

/// Holds information about touch response in the [PieChart].
///
/// You can override [PieTouchData.touchCallback] to handle touch events,
/// it gives you a [PieTouchResponse] and you can do whatever you want.
class PieTouchResponse extends BaseTouchResponse {
  /// If touch happens, [PieChart] processes it internally and passes out a [PieTouchResponse]
  PieTouchResponse({
    required super.touchLocation,
    required this.touchedSection,
  });

  /// Contains information about touched section, like index, angle, radius, ...
  final PieTouchedSection? touchedSection;

  /// Copies current [PieTouchResponse] to a new [PieTouchResponse],
  /// and replaces provided values.
  PieTouchResponse copyWith({
    Offset? touchLocation,
    PieTouchedSection? touchedSection,
  }) =>
      PieTouchResponse(
        touchLocation: touchLocation ?? this.touchLocation,
        touchedSection: touchedSection ?? this.touchedSection,
      );
}

/// It lerps a [PieChartData] to another [PieChartData] (handles animation for updating values)
class PieChartDataTween extends Tween<PieChartData> {
  PieChartDataTween({required PieChartData begin, required PieChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [PieChartData] based on [t] value, check [Tween.lerp].
  @override
  PieChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
