import 'package:d3_force_flutter/d3_force_flutter.dart' as f;
import 'package:flutter/material.dart';

part 'education.dart';
part 'experience.dart';
part 'interests.dart';
part 'projects.dart';
part 'skills.dart';

enum ResumeNodeType {
  education,
  project,
  experience,
  skill,
  interest,
}

abstract class ResumeNode extends f.Node {
  ResumeNode(this.type, this.title);

  final ResumeNodeType type;
  final String title;

  Widget build(BuildContext context);
}

final List<ResumeNode> resumeNodes = [
  _test1,
  _test2,
  _test3,
  _test4,
];

final Map<ResumeNode, Set<ResumeNode>?> _resumeEdges = {
  _test1: {
    _test2,
    _test3,
    _test4,
  },
  _test2: {
    _test3,
  }
};

final List<f.Edge<ResumeNode>> resumeEdges = _resumeEdges.entries
    .expand(
      (edge) =>
          {...?edge.value?.map((n) => f.Edge(source: edge.key, target: n))},
    )
    .toList();
