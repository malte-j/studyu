// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudySchedule _$StudyScheduleFromJson(Map<String, dynamic> json) =>
    StudySchedule(
      (json['interventions'] as List<dynamic>)
          .map((e) => Intervention.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['segments'] as List<dynamic>)
          .map((e) => StudyScheduleSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudyScheduleToJson(StudySchedule instance) =>
    <String, dynamic>{
      'interventions': instance.interventions.map((e) => e.toJson()).toList(),
      'segments': instance.segments.map((e) => e.toJson()).toList(),
    };

StudyScheduleSegment _$StudyScheduleSegmentFromJson(
        Map<String, dynamic> json) =>
    StudyScheduleSegment();

Map<String, dynamic> _$StudyScheduleSegmentToJson(
        StudyScheduleSegment instance) =>
    <String, dynamic>{};

Baseline _$BaselineFromJson(Map<String, dynamic> json) => Baseline(
      json['duration'] as int,
    );

Map<String, dynamic> _$BaselineToJson(Baseline instance) => <String, dynamic>{
      'duration': instance.duration,
    };

Alternating _$AlternatingFromJson(Map<String, dynamic> json) => Alternating(
      json['interventionDuration'] as int,
      json['cycleAmount'] as int,
    );

Map<String, dynamic> _$AlternatingToJson(Alternating instance) =>
    <String, dynamic>{
      'interventionDuration': instance.interventionDuration,
      'cycleAmount': instance.cycleAmount,
    };
