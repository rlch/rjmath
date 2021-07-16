import 'package:rjmath/models/nodes/node.dart';
import 'package:rjmath/widgets/simulation_canvas.dart';
import 'package:flutter/material.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart';

class SimulationCanvasObject
    extends ParentDataWidget<SimulationCanvasParentData> {
  const SimulationCanvasObject({
    required Widget child,
    required this.node,
    required this.edges,
    required this.constraints,
    required this.edgeColor,
    this.arrowHeight = 10,
    this.arrowWidth = 10,
    Key? key,
  }) : super(child: child, key: key);

  final ResumeNode node;
  final List<Edge<ResumeNode>> edges;
  final BoxConstraints constraints;
  final double arrowHeight, arrowWidth;
  final Color edgeColor;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as SimulationCanvasParentData;

    if (parentData.offset != Offset(node.x, node.y)) {
      parentData.offset = Offset(node.x, node.y);
    }

    if (parentData.edges != edges) {
      parentData.edges = edges;
    }

    if (parentData.constraints != constraints) {
      parentData.constraints = constraints;
    }

    if (parentData.edgeColor != edgeColor) {
      parentData.edgeColor = edgeColor;
    }

    if (parentData.arrowHeight != arrowHeight) {
      parentData.arrowHeight = arrowHeight;
    }

    if (parentData.arrowWidth != arrowWidth) {
      parentData.arrowWidth = arrowWidth;
    }

    if (parentData.node != node) {
      parentData.node = node;
    }

    final targetObject = renderObject.parent;
    if (targetObject is RenderObject) {
      targetObject.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => SimulationCanvas;
}
