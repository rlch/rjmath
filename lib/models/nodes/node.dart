import 'package:flutter/material.dart';

part 'education.dart';
part 'experience.dart';
part 'interests.dart';
part 'projects.dart';
part 'skills.dart';

enum NodeType {
  education,
  project,
  experience,
  skill,
  interest,
}

abstract class INode {
  INode._(this.type, this.title);

  final NodeType type;
  final String title;

  Widget build(BuildContext context);
}

final resumeNodes = [
  ..._skills,
];
