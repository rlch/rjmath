part of 'node.dart';

class Skill extends ResumeNode {
  Skill({
    required this.title,
  }) : super(ResumeNodeType.skill);

  final String title;

  @override
  bool operator ==(Object o) => o is Skill && o.title == title;
  @override
  int get hashCode => title.hashCode;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      textAlign: TextAlign.center,
      minFontSize: 8,
      wrapWords: false,
    );
  }
}

final _dartFlutter = Skill(title: 'Dart/Flutter'),
    _python = Skill(title: 'Python'),
    _r = Skill(title: 'R'),
    _ds = Skill(title: 'Data Science'),
    _tf = Skill(title: 'TensorFlow'),
    _dp = Skill(title: 'Data processing'),
    _crypto = Skill(title: 'Cryptography'),
    _math = Skill(title: 'Mathematics'),
    _graphTheory = Skill(title: 'Graph Theory');
