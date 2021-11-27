import 'dart:math';

import 'package:rjmath/extensions/color.dart';
import 'package:rjmath/models/nodes/node.dart';
import 'package:rjmath/models/simulation_parameters.dart';
import 'package:rjmath/rendering/node_hit_test.dart';
import 'package:rjmath/rendering/simulation_canvas.dart';
import 'package:rjmath/rendering/simulation_canvas_object.dart';
import 'package:rjmath/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as f;

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({Key? key}) : super(key: key);

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final TransformationController _transformationController;

  late f.ForceSimulation<ResumeNode> _simulation;
  f.ForceSimulation<ResumeNode> get simulation => _simulation;
  final List<f.Edge<ResumeNode>> edges = resumeEdges;
  late final List<int> edgeCounts;

  final double sidebarWidth = 300;
  final double maxNodeRadius = 30, minNodeRadius = 15;
  final double collisionDistance = 2;

  late SimulationParameters _simulationParameters;

  int maxEdgeCount = 0;

  int? selectedNodeIndex;
  Set<int>? activeNodes;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  bool _initialized = false;
  void initSimulation() {
    if (_initialized) return;
    _initialized = true;

    resetSimulation();

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
      node.weight = maxEdgeCount == 0 ? 0 : edgeCounts[node.index!] / maxEdgeCount;
      node.radius = minNodeRadius + node.weight * (maxNodeRadius - minNodeRadius);
    }
  }

  void resetSimulation() {
    final size = MediaQuery.of(context).size;
    _simulationParameters = SimulationParameters(
      screenWidth: size.width,
      screenHeight: size.height,
      xPositioning: size.width / 2,
      yPositioning: size.height / 2,
      alpha: 1,
      collisionForce: maxNodeRadius * 2 + collisionDistance,
      radialForce: 600,
      manyBodyForce: -10,
      edgesForce: 100,
    );

    _simulation = f.ForceSimulation(
      phyllotaxisX: _simulationParameters.xPositioning(),
      phyllotaxisY: _simulationParameters.yPositioning(),
      phyllotaxisRadius: _simulationParameters.radialForce(),
    )..nodes = resumeNodes;

    applySimulationParameters();
  }

  void applySimulationParameters() {
    simulation
      ..setForce('collide', f.Collide(radius: _simulationParameters.collisionForce()))
      ..setForce('radial', f.Radial(radius: _simulationParameters.radialForce()))
      ..setForce('manyBody', f.ManyBody(strength: _simulationParameters.manyBodyForce()))
      ..setForce(
        'edges',
        f.Edges(edges: edges, distance: _simulationParameters.edgesForce()),
      )
      ..alpha = _simulationParameters.alpha()
      ..setForce('x', f.XPositioning(x: _simulationParameters.xPositioning()))
      ..setForce('y', f.YPositioning(y: _simulationParameters.yPositioning()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initSimulation();
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
    final theme = Theme.of(context);

    final nodeColor = theme.primaryColor;
    final background = theme.scaffoldBackgroundColor;
    final edgeColor = theme.dividerColor;
    final size = MediaQuery.of(context).size;

    return SimulationParametersScope(
      _simulationParameters,
      child: Scaffold(
        body: Builder(builder: (context) {
          return Stack(
            children: [
              InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.2,
                maxScale: 2,
                boundaryMargin: EdgeInsets.all(size.width * 2),
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 0.5),
                    child: SimulationCanvas(
                      children: [
                        for (final node in simulation.nodes)
                          if (!node.isNaN)
                            Builder(
                              builder: (context) {
                                final radius = node.radius, weight = node.weight;
                                return SimulationCanvasObject(
                                  arrowHeight: 5,
                                  arrowWidth: 5,
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
                                      final localPosition = _transformationController.toScene(update.globalPosition);
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
                                          top: radius * 2 - 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: node.type.color.darken(),
                                              ),
                                              color: node.type.color,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 2,
                                              horizontal: 5,
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
                  ),
                ),
              ),
              Positioned(
                left: 0,
                width: sidebarWidth,
                height: size.height,
                child: SimulationSidebar(
                  backgroundColor: background,
                  onParametersChanged: (params) {
                    _simulationParameters = params;
                    applySimulationParameters();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _transformationController.value = Matrix4.identity(),
                        icon: Icon(Icons.keyboard_return),
                        color: background.lighten(0.4),
                      ),
                      IconButton(
                        onPressed: resetSimulation,
                        icon: Icon(Icons.refresh),
                        color: background.lighten(0.4),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
