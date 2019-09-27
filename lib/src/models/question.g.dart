// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return QuestionModel(
      question: json['question'] as String,
      answers: (json['answers'] as Map<String, dynamic>)?.map(
        (k, e) =>
            MapEntry(_$enumDecodeNullable(_$TendencyEnumMap, k), e as String),
      ));
}

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answers':
          instance.answers?.map((k, e) => MapEntry(_$TendencyEnumMap[k], e))
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$TendencyEnumMap = <Tendency, dynamic>{
  Tendency.driver: 'driver',
  Tendency.amiable: 'amiable',
  Tendency.analytical: 'analytical',
  Tendency.expressive: 'expressive'
};

Questionairre _$QuestionairreFromJson(Map<String, dynamic> json) {
  return Questionairre((json['questions'] as List)
      ?.map((e) =>
          e == null ? null : QuestionModel.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$QuestionairreToJson(Questionairre instance) =>
    <String, dynamic>{
      'questions': instance.questions?.map((e) => e?.toJson())?.toList()
    };
