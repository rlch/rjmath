part of 'node.dart';

class Education extends ResumeNode {
  Education({
    required this.title,
    required this.range,
  }) : super(ResumeNodeType.education);

  final String title;
  final DateTimeRange range;

  @override
  bool operator ==(Object o) => o is Education && o.title == title;
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

final _stl = Education(
      title: 'St. Leonard\'s College',
      range: DateTimeRange(start: DateTime(2012), end: DateTime(2017)),
    ),
    _unimelb = Education(
      title: 'Melbourne University',
      range: DateTimeRange(start: DateTime(2018), end: DateTime(2022)),
    ),
    _ib = Education(
      title: 'International Baccalaureate',
      range: DateTimeRange(start: DateTime(2016), end: DateTime(2017)),
    ),
    _act = Education(
      title: 'Actuarial Science',
      range: DateTimeRange(
        start: DateTime(2018),
        end: DateTime(2022),
      ),
    ),
    _bcom = Education(
      title: 'Bachelor of Commerce',
      range: DateTimeRange(start: DateTime(2018), end: DateTime(2022)),
    );
