import 'dart:math';

import 'package:d3_force_flutter/d3_force_flutter.dart' hide Center;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rjmath/models/nodes/node.dart';
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
    required this.node,
    required this.edges,
    required this.constraints,
    required this.edgeColor,
    required this.arrowWidth,
    required this.arrowHeight,
  });

  ResumeNode node;
  List<Edge<ResumeNode>> edges;
  Color edgeColor;
  double arrowWidth, arrowHeight;
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
        node: Skill(title: ''),
        edges: [],
        edgeColor: Colors.grey,
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
      final centerOffset = Offset(pd.node.radius, pd.node.radius);

      for (final edge in pd.edges) {
        ///? can't get parentData of this node
        final e = edge.target;

        final Vector3 A = (pd.offset + offset + centerOffset).vec,
            B = (Offset(e.x + e.radius, e.y + e.radius) + offset).vec,
            V = (B - A).normalized();
        final vA = V * pd.node.radius,
            vB = V * e.radius,
            vtB = V * (e.radius + pd.arrowHeight);

        final edgeA = A + vA, edgeB = B - vB;
        final edgePaint = Paint()
          ..color = Colors.grey.withOpacity(pd.node.weight)
          ..strokeWidth = 0.75;

        final orthog = Vector3(-V.y, V.x, 0);
        final triangleEnd = (B - vtB);
        final edgeBt1 = triangleEnd + orthog * (pd.arrowWidth / 2),
            edgeBt2 = triangleEnd - orthog * (pd.arrowWidth / 2);

        canvas
          ..drawLine(
            edgeA.offset,
            (B - vtB).offset,
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
    // double xStart = 0, xEnd = 0, yStart = 0, yEnd = 0;
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

      // xStart = min(xStart, childParentData.offset.dx);
      // xEnd = max(
      //   xEnd,
      //   childParentData.offset.dx + childParentData.constraints.maxWidth,
      // );

      // yStart = min(yStart, childParentData.offset.dy);
      // yEnd = max(
      //   yEnd,
      //   childParentData.offset.dy + childParentData.constraints.maxHeight,
      // );

      child = childParentData.nextSibling;
    }

    return constraints.biggest;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double start = 0, end = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      start = min(start, childParentData.offset.dy);
      end = max(
        end,
        childParentData.offset.dy + child.getMaxIntrinsicHeight(width),
      );

      child = childParentData.nextSibling;
    }

    return end - start;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double start = 0, end = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      start = min(start, childParentData.offset.dy);
      end = max(
        end,
        childParentData.offset.dy + child.getMinIntrinsicHeight(width),
      );

      child = childParentData.nextSibling;
    }

    return end - start;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double start = 0, end = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      start = min(start, childParentData.offset.dx);
      end = max(
        end,
        childParentData.offset.dx + child.getMaxIntrinsicWidth(height),
      );

      child = childParentData.nextSibling;
    }

    return end - start;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    double start = 0, end = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as SimulationCanvasParentData;
      start = min(start, childParentData.offset.dx);
      end = max(
        end,
        childParentData.offset.dx + child.getMinIntrinsicWidth(height),
      );

      child = childParentData.nextSibling;
    }

    return end - start;
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
