import 'package:auto_size_text/auto_size_text.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../unbounded_date_time_range.dart';

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
  ResumeNodeType get type;
  double weight = 1, radius = 50;

  Widget build(BuildContext context);
}

final List<ResumeNode> resumeNodes = [
  _tutero,
  _mm,
  _rust,
  _lua,
  _cs,
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
  _gameDev,
  _unity,
  _csharp,
  _js,
  _ts,
  _neo4j,
];

final Map<ResumeNode, Set<ResumeNode>?> _resumeEdges = {
  _cs: {
    _ds,
    _r,
    _rust,
    _lua,
    _python,
    _csharp,
    _js,
    _ts,
    _neo4j,
  },
  _neo4j: {_graphTheory},
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
    _rust,
  },
  _math: {
    _graphTheory,
    _crypto,
    _act,
    _gameDev,
  },
  _stl: {
    _ib,
    _japanese,
    _spanish,
    _math,
  },
  _unimelb: {
    _bcom,
    _act,
    _math,
  },
  _act: {
    _r,
    _ds,
  },
  _gaming: {
    _gameDev,
  },
  _gameDev: {
    _unity,
    _dartFlutter,
  },
  _unity: {
    _csharp,
  },
  _tutero: {
    _dartFlutter,
    _neo4j,
    _rust,
    _js,
    _ts,
    _math,
    _graphTheory,
  },
  _mm: {
    _dartFlutter,
  },
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
