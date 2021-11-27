part of 'node.dart';

class Skill extends ResumeNode {
  Skill({required this.title});

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
      presetFontSizes: presetFontSizes,
      wrapWords: false,
    );
  }

  @override
  ResumeNodeType get type => ResumeNodeType.skill;
}

final _dartFlutter = Skill(title: 'Dart/Flutter'),
    _rust = Skill(title: 'Rust'),
    _lua = Skill(title: 'Lua'),
    _js = Skill(title: 'JavaScript'),
    _ts = Skill(title: 'TypeScript'),
    _python = Skill(title: 'Python'),
    _neo4j = Skill(title: 'Neo4J'),
    _r = Skill(title: 'R'),
    _ds = Skill(title: 'Data Science'),
    _cs = Skill(title: 'Computer Science'),
    _tf = Skill(title: 'TensorFlow'),
    _dp = Skill(title: 'Data processing'),
    _crypto = Skill(title: 'Cryptography'),
    _math = Skill(title: 'Mathematics'),
    _graphTheory = Skill(title: 'Graph Theory'),
    _unity = Skill(title: 'Unity'),
    _csharp = Skill(title: 'C#');
