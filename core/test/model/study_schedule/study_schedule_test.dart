import 'package:studyu_core/src/models/interventions/interventions.dart';
import 'package:studyu_core/src/models/study_schedule/study_schedule.dart';
import 'package:test/test.dart';

void main() {
  group('StudySchedule', () {
    test('should calculate the correct duration', () {
      final interventions = [
        Intervention("int1", "tea"),
        Intervention("int2", "coffee"),
      ];

      final segments = [
        Baseline(7),
        Alternating(2, 2),
      ];

      final schedule = StudySchedule(interventions, segments);
      expect(schedule.duration, 14);
    });
  });
}
