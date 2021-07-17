import 'dart:math';

import 'package:rjmath/extensions/color.dart';
import 'package:rjmath/models/nodes/node.dart';
import 'package:rjmath/widgets/node_hit_test.dart';
import 'package:rjmath/widgets/simulation_canvas.dart';
import 'package:rjmath/widgets/simulation_canvas_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as f;

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({Key? key}) : super(key: key);

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final TransformationController _transformationController;

  late final f.ForceSimulation<ResumeNode> simulation;
  final List<f.Edge<ResumeNode>> edges = resumeEdges;
  late final List<int> edgeCounts;
  final double maxNodeRadius = 60, minNodeRadius = 30;
  int maxEdgeCount = 0;

  int? selectedNodeIndex;
  Set<int>? activeNodes;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.of(context).size;

    simulation = f.ForceSimulation(
      phyllotaxisX: size.width / 2,
      phyllotaxisY: size.height / 2,
      phyllotaxisRadius: 20,
    )
      ..nodes = resumeNodes
      ..setForce('collide', f.Collide(radius: maxNodeRadius * 2 + 5))
      ..setForce('radial', f.Radial(radius: 400))
      ..setForce('manyBody', f.ManyBody(strength: -10))
      // ..setForce(
      //     'center', f.Center(size.width / 2, size.height / 2, strength: 0.5))
      ..setForce(
        'edges',
        f.Edges(edges: edges, distance: 200),
      )
      ..setForce('x', f.XPositioning(x: size.width / 2))
      ..setForce('y', f.YPositioning(y: size.height / 2))
      ..alpha = 2;

    _ticker = this.createTicker((_) {
      setState(() => simulation.tick());
    })
      ..start();

    edgeCounts = List.filled(resumeNodes.length, 0);
    for (int i = 0; i < edges.length; i++) {
      final edge = edges[i];
      edge.index = i;
      edgeCounts[edge.source.index!] += 1;
      edgeCounts[edge.target.index!] += 1;
    }
    for (final count in edgeCounts) {
      if (count > maxEdgeCount) maxEdgeCount = count;
    }
    for (final node in simulation.nodes) {
      node.weight =
          maxEdgeCount == 0 ? 0 : edgeCounts[node.index!] / maxEdgeCount;
      node.radius =
          minNodeRadius + node.weight * (maxNodeRadius - minNodeRadius);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void startTicker() => _ticker..start();

  @override
  Widget build(BuildContext context) {
    final nodeColor = Theme.of(context).primaryColor;
    final edgeColor = Theme.of(context).dividerColor;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Builder(builder: (viewerContext) {
        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.2,
          maxScale: 2,
          boundaryMargin: EdgeInsets.all(size.width * 2),
          child: SimulationCanvas(
            children: [
              for (final node in simulation.nodes)
                if (!node.isNaN)
                  Builder(
                    builder: (context) {
                      final radius = node.radius, weight = node.weight;
                      return SimulationCanvasObject(
                        constraints: BoxConstraints.tight(
                          Size(radius * 2, radius * 2),
                        ),
                        node: node,
                        edges: [...edges.where((e) => e.source == node)],
                        edgeColor: edgeColor,
                        child: NodeHitTester(
                          node,
                          onTap: () {
                            setState(() => selectedNodeIndex = node.index);
                          },
                          onDragUpdate: (update) {
                            final localPosition = _transformationController
                                .toScene(update.globalPosition);
                            node
                              ..fx = localPosition.dx - radius
                              ..fy = localPosition.dy - radius;
                            simulation..alphaTarget = 0.5;
                          },
                          onDragEnd: (_) {
                            node
                              ..fx = null
                              ..fy = null;
                            simulation.alphaTarget = 0;
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: radius * 2,
                                height: radius * 2,
                                decoration: BoxDecoration(
                                  border: Border.all(color: nodeColor),
                                  color: nodeColor.withOpacity(sqrt(weight)),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: node.build(context),
                              ),
                              Positioned(
                                bottom: -10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: node.type.color.darken(),
                                    ),
                                    color: node.type.color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    node.type.string,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      }),
    );
  }
}
