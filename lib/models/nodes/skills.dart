part of 'node.dart';

class Skill implements INode {
  Skill({
    required this.title,
  });

  @override
  final type = NodeType.skill;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

final List<Skill> _skills = [
  Skill(title: 'Test'),
  Skill(title: 'Another Tes'),
];
