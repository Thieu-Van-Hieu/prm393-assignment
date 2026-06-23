import 'package:dart_mappable/dart_mappable.dart';

part 'subject_type.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum SubjectType {
  @MappableValue('NUMERIC')
  numeric('Tính điểm số'),
  @MappableValue('QUALITATIVE')
  qualitative('Đánh giá định tính');

  final String label;

  const SubjectType(this.label);

  static SubjectType fromString(String? type) {
    if (type == null) return SubjectType.numeric;
    try {
      return SubjectTypeMapper.fromValue(type.toUpperCase());
    } catch (_) {
      return SubjectType.numeric;
    }
  }
}
