part of 'node.dart';

class Skill extends ResumeNode {
  Skill({
    required String title,
  }) : super(
          ResumeNodeType.skill,
          title,
        );

  @override
  bool operator ==(Object o) => o is Skill && o.title == title;
  @override
  int get hashCode => title.hashCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        Text(
          'Skill',
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }
}

final _test1 = Skill(title: 'Dart/Flutter'),
    _test2 = Skill(title: 'Python'),
    _test3 = Skill(title: 'R'),
    _test4 = Skill(title: 'ML');
