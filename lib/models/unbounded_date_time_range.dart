import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

@immutable
class UnboundedDateTimeRange {
  /// Creates a date range for the given start and end [DateTime].
  UnboundedDateTimeRange({this.start, this.end});

  /// The start of the range of dates.
  final DateTime? start;

  /// The end of the range of dates.
  final DateTime? end;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is UnboundedDateTimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => hashValues(start, end);

  String format([DateFormat? df]) {
    df ??= DateFormat.y();
    return '${start == null ? '' : '${df.format(start!)} '}\u2014${end == null ? '' : ' ${df.format(end!)}'}';
  }
}
