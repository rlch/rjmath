import 'dart:math';

import 'package:d3_force_flutter/d3_force_flutter.dart' hide Center;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

extension on Offset {
  Vector3 get vec => Vector3(dx, dy, 0);
}

extension on Vector3 {
  Offset get offset => Offset(x, y);
}

class SimulationCanvas extends MultiChildRenderObjectWidget {
  SimulationCanvas({
    required List<Widget> children,
    Key? key,
  }) : super(children: children, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSimulationCanvas();
  }
}

class SimulationCanvasParentData extends ContainerBoxParentData<RenderBox> {
  SimulationCanvasParentData({
    required this.edges,
    required this.weight,
    required this.nodeRadius,
    required this.constraints,
    required this.edgeColor,
    required this.arrowWidth,
    required this.arrowHeight,
  });

  List<Edge> edges;
  Color edgeColor;
  double weight, nodeRadius, arrowWidth, arrowHeight;
  BoxConstraints constraints;
}

class RenderSimulationCanvas extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SimulationCanvasParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SimulationCanvasParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SimulationCanvasParentData) {
      child.parentData = SimulationCanvasParentData(
        edges: [],
        edgeColor: Colors.grey,
        weight: 0,
        nodeRadius: 0,
        arrowWidth: 0,
        arrowHeight: 0,
        constraints: BoxConstraints.tight(Size(0, 0)),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();

    RenderBox? child = firstChild;

    while (child != null) {
      final pd = child.parentData! as SimulationCanvasParentData;
      final centerOffset = Offset(child.size.width / 2, child.size.height / 2);
      final canvasOffset = offset + centerOffset;

      for (final edge in pd.edges) {
        final e = edge.target;

        final Vector3 A = (pd.offset + canvasOffset).vec,
            B = (Offset(e.x, e.y) + canvasOffset).vec,
            V = (B - A).normalized();
        final v = V * pd.nodeRadius, vt = V * (pd.nodeRadius + pd.arrowHeight);

        final edgeA = A + v, edgeB = B - v;
        final edgePaint = Paint()
          ..color = Colors.grey.withOpacity(pd.weight)
          ..strokeWidth = 0.75;

        final orthog = Vector3(-V.y, V.x, 0);
        final triangleEnd = (B - vt);
        final edgeBt1 = triangleEnd + orthog * (pd.arrowWidth / 2),
            edgeBt2 = triangleEnd - orthog * (pd.arrowWidth / 2);

        canvas
          ..drawLine(
            edgeA.offset,
            (B - vt).offset,
            edgePaint,
          )
          ..drawPath(
            Path()
              ..lineTo(edgeB.x, edgeB.y)
              ..lineTo(edgeBt1.x, edgeBt1.y)
              ..lineTo(edgeBt2.x, edgeBt2.y)
              ..lineTo(edgeB.x, edgeB.y),
            edgePaint,
          );
      }
      child = pd.nextSibling;
    }

    child = firstChild;
    while (child != null) {
      final pd = child.parentData! as SimulationCanvasParentData;
      context.paintChild(child, pd.offset + offset);
      child = pd.nextSibling;
    }

    canvas.restore();
  }

  @override
  void performLayout() {
    size = _computeLayoutSize(constraints: constraints, dry: false);
  }

  Size _computeLayoutSize({
    required BoxConstraints constraints,
    required bool dry,
  }) {
    RenderBox? child = firstChild;

    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;

      if (!dry) {
        child.layout(
          childParentData.constraints,
          parentUsesSize: true,
        );
      } else {
        child.getDryLayout(childParentData.constraints);
      }

      child = childParentData.nextSibling;
    }

    return constraints.biggest;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double height = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      height += child.getMinIntrinsicHeight(width);

      child = childParentData.nextSibling;
    }

    return height;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      width = max(width, child.getMaxIntrinsicWidth(height));

      child = childParentData.nextSibling;
    }

    return width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    double width = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      width = max(width, child.getMinIntrinsicWidth(height));

      child = childParentData.nextSibling;
    }

    return width;
  }

  /// Baseline
  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
