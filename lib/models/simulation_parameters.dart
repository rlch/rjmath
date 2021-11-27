import 'dart:math' as math;
import 'package:flutter/widgets.dart';

class SimulationParametersScope extends InheritedWidget {
  SimulationParametersScope(
    this.parameters, {
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  final SimulationParameters parameters;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is SimulationParametersScope && parameters != oldWidget.parameters;
}

class SimulationParameters {
  SimulationParameters({
    required double xPositioning,
    required double yPositioning,
    required double collisionForce,
    required double radialForce,
    required double alpha,
    required double edgesForce,
    required double manyBodyForce,
    required double screenWidth,
    required double screenHeight,
  })  : collisionForce = RangedSimulationParameter(
          collisionForce,
          title: 'Collision Force',
          description:
              r'The collision force $F$ constrains the distance between nodes $a$, $b$ such that $d(a, b) \geq r(a) + r(b) + F$.',
          min: 0,
          max: 300,
        ),
        radialForce = RangedSimulationParameter(
          radialForce,
          title: 'Radial Force',
          description:
              r'The radial force $R$ creates a positional force towards a circle of radius $R$, centered at $(x, y)$',
          min: 0,
          max: 1000,
        ),
        alpha = RangedSimulationParameter(
          alpha,
          title: 'Alpha',
          description: r'Analagous to temperature in simulated annealing.',
          min: 0,
          max: 3,
        ),
        edgesForce = RangedSimulationParameter(
          edgesForce,
          title: 'Edge Distance',
          description: r'For a given edge $e=(a, b)$, edge distance $D$ constrains $d(e) \geq D.$',
          min: 0,
          max: 300,
        ),
        manyBodyForce = RangedSimulationParameter(
          manyBodyForce,
          min: -200,
          max: 200,
          title: 'Many-Body Force',
          description:
              r'Applies equally amongst all nodes, simulates attraction when positive, and repulsion when negative.',
        ),
        xPositioning = RangedSimulationParameter(
          xPositioning,
          min: 0,
          max: screenWidth,
          title: 'Horizontal Positional Force',
          description: r'The $x$-positioning force pushes a node by $x$ pixels along the horizontal axis.',
        ),
        yPositioning = RangedSimulationParameter(
          yPositioning,
          min: 0,
          max: screenHeight,
          title: 'Vertical Positional Force',
          description: r'The $y$-positioning force pushes a node by $y$ pixels along the vertical axis.',
        );

  final RangedSimulationParameter collisionForce,
      radialForce,
      alpha,
      edgesForce,
      manyBodyForce,
      xPositioning,
      yPositioning;

  List<RangedSimulationParameter> get rangedParameters => [
        alpha,
        manyBodyForce,
        radialForce,
        edgesForce,
        collisionForce,
        xPositioning,
        yPositioning,
      ];

  static SimulationParameters of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SimulationParametersScope>()!.parameters;
  }
}

abstract class SimulationParameter<T> {
  SimulationParameter(this._value);

  T _value;
  set value(T value) => _value = value;
  String get title;
  String get description;

  T call() => _value;
}

class RangedSimulationParameter extends SimulationParameter<double> {
  RangedSimulationParameter(
    double value, {
    required this.min,
    required this.max,
    required this.title,
    required this.description,
  })  : assert(min <= max),
        super(value) {
    final eps = 1e-7;
    value = math.max(math.min(value, max - eps), min + eps);
  }

  final String title;
  final String description;
  final double min, max;
}
