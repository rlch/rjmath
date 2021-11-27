part of 'node.dart';

class Education extends ResumeNode {
  Education({
    required this.title,
    required this.range,
  });

  final String title;
  final UnboundedDateTimeRange range;

  @override
  bool operator ==(Object o) => o is Education && o.title == title;
  @override
  int get hashCode => title.hashCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoSizeText(
          title,
          textAlign: TextAlign.center,
          wrapWords: false,
          presetFontSizes: presetFontSizes,
        ),
        const SizedBox(height: 3),
        AutoSizeText(
          range.format(),
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
          maxLines: 1,
          presetFontSizes: presetFontSizes,
        )
      ],
    );
  }

  @override
  ResumeNodeType get type => ResumeNodeType.education;
}

final _stl = Education(
      title: 'St. Leonard\'s College',
      range: UnboundedDateTimeRange(start: DateTime(2012), end: DateTime(2017)),
    ),
    _unimelb = Education(
      title: 'Melbourne University',
      range: UnboundedDateTimeRange(start: DateTime(2018), end: DateTime(2022)),
    ),
    _ib = Education(
      title: 'International Baccalaureate',
      range: UnboundedDateTimeRange(start: DateTime(2016), end: DateTime(2017)),
    ),
    _act = Education(
      title: 'Actuarial Science',
      range: UnboundedDateTimeRange(
        start: DateTime(2018),
        end: DateTime(2022),
      ),
    ),
    _bcom = Education(
      title: 'Bachelor of Commerce',
      range: UnboundedDateTimeRange(start: DateTime(2018), end: DateTime(2022)),
    );
