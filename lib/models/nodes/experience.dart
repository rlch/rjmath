part of 'node.dart';

class Experience extends ResumeNode {
  Experience({
    required this.company,
    required this.position,
    required this.range,
  });

  final String company;
  final String position;
  final UnboundedDateTimeRange range;

  @override
  bool operator ==(Object o) => o is Experience && o.company == company && o.position == position && o.range == range;
  @override
  int get hashCode => hashValues(company, position, range);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            company,
            textAlign: TextAlign.center,
            wrapWords: false,
            style: Theme.of(context).textTheme.subtitle2,
            presetFontSizes: presetFontSizes,
          ),
          const SizedBox(height: 3),
          AutoSizeText(
            position,
            textAlign: TextAlign.center,
            wrapWords: false,
            presetFontSizes: presetFontSizes,
          ),
          const SizedBox(height: 3),
          AutoSizeText(
            range.format(DateFormat('y MMM')),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
            maxLines: 1,
            presetFontSizes: presetFontSizes,
          )
        ],
      ),
    );
  }

  @override
  ResumeNodeType get type => ResumeNodeType.experience;
}

final _tutero = Experience(
      company: 'Tutero',
      position: 'CTO & Co-Founder',
      range: UnboundedDateTimeRange(start: DateTime(2020, 1)),
    ),
    _mm = Experience(
      company: 'Mandy Money',
      position: 'Tech Lead',
      range: UnboundedDateTimeRange(
        start: DateTime(2019, 11),
        end: DateTime(2020, 1),
      ),
    );
