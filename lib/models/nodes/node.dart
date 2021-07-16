import 'package:auto_size_text/auto_size_text.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

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

extension ResumeNodeTypeX on ResumeNodeType {
  String get string {
    switch (this) {
      case ResumeNodeType.education:
        return 'Education';
      case ResumeNodeType.project:
        return 'Project';
      case ResumeNodeType.experience:
        return 'Experience';
      case ResumeNodeType.skill:
        return 'Skill';
      case ResumeNodeType.interest:
        return 'Interest';
    }
  }

  Color get color {
    switch (this) {
      case ResumeNodeType.education:
        return NordColors.aurora.orange;
      case ResumeNodeType.project:
        return NordColors.aurora.green;
      case ResumeNodeType.experience:
        return NordColors.aurora.red;
      case ResumeNodeType.skill:
        return NordColors.aurora.yellow;
      case ResumeNodeType.interest:
        return NordColors.aurora.purple;
    }
  }
}

abstract class ResumeNode extends f.Node {
  ResumeNode(this.type);

  final ResumeNodeType type;
  double weight = 1, radius = 50;

  Widget build(BuildContext context);
}

final List<ResumeNode> resumeNodes = [
  _dartFlutter,
  _python,
  _ds,
  _r,
  _tf,
  _dp,
  _crypto,
  _math,
  _languages,
  _spanish,
  _japanese,
  _graphTheory,
  _gaming,
  _stl,
  _unimelb,
  _ib,
  _act,
  _bcom,
];

final Map<ResumeNode, Set<ResumeNode>?> _resumeEdges = {
  _ds: {
    _python,
    _r,
    _tf,
    _dp,
  },
  _languages: {
    _japanese,
    _spanish,
  },
  _dp: {
    _python,
    _r,
  },
  _python: {
    _tf,
  },
  _crypto: {
    _python,
    _dartFlutter,
  },
  _math: {
    _graphTheory,
    _crypto,
    _act,
  },
  _stl: {
    _ib,
    _japanese,
    _spanish,
  },
  _unimelb: {
    _bcom,
    _act,
    _math,
  },
  _act: {
    _r,
    _ds,
  }
};

final List<f.Edge<ResumeNode>> resumeEdges = _resumeEdges.entries
    .expand(
      (edge) => {
        ...?edge.value?.map(
          (n) => f.Edge(
            source: edge.key,
            target: n,
          ),
        )
      },
    )
    .toList();
