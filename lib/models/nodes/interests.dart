part of 'node.dart';

class Interest extends ResumeNode {
  Interest({required this.title}) : super(ResumeNodeType.interest);

  final String title;

  @override
  bool operator ==(Object o) => o is Interest && o.title == title;
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

final _japanese = Interest(title: '日本語'),
    _spanish = Interest(title: 'Español'),
    _languages = Interest(title: 'Languages'),
    _gaming = Interest(title: 'Gaming');
