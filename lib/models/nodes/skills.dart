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
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }
}

final _test1 = Skill(title: 'test1'),
    _test2 = Skill(title: 'test2'),
    _test3 = Skill(title: 'test3'),
    _test4 = Skill(title: 'test4');
