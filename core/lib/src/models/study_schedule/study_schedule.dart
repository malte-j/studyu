// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:json_annotation/json_annotation.dart';
import 'package:studyu_core/src/models/interventions/interventions.dart';

part 'study_schedule.g.dart';

@JsonSerializable()
class StudySchedule {
  List<Intervention> interventions = [];
  List<StudyScheduleSegment> segments = [];

  StudySchedule(this.interventions, this.segments);

  int get duration =>
      segments.map((e) => e.getDuration(interventions)).reduce((a, b) => a + b);

  /// Returns the segment for the given day and the nth day of the segment
  (StudyScheduleSegment?, int) getSegmentForDay(int day) {
    if (day > duration || day < 0)
      throw ArgumentError("Day must be between 0 and $duration");

    int remainingDays = day;

    for (final segment in segments) {
      final int segmentDuration = segment.getDuration(interventions);
      if (segmentDuration > remainingDays) {
        return (segment, remainingDays);
      } else {
        remainingDays -= segmentDuration;
      }
    }

    throw StateError("This should never happen");
  }

  Intervention? getInterventionForDay(int day) {
    final (segment, dayInSegment) = getSegmentForDay(day);
    return segment?.getIntervetionOnDay(dayInSegment, interventions);
  }
}

@JsonSerializable()
abstract class StudyScheduleSegment {
  int getDuration(List<Intervention> interventions);

  Intervention? getIntervetionOnDay(int day, List<Intervention> interventions);

  String get type =>
      throw UnimplementedError("Subclasses should return String type");
}

@JsonSerializable()
class Baseline extends StudyScheduleSegment {
  final int duration;

  @override
  final String type = "baseline";

  @override
  int getDuration(List<Intervention> interventions) {
    return duration;
  }

  @override
  Intervention? getIntervetionOnDay(int day, List<Intervention> interventions) {
    return null;
  }

  Baseline(this.duration);
}

@JsonSerializable()
class Alternating extends StudyScheduleSegment {
  @override
  final String type = "alterating";

  int interventionDuration;
  int cycleAmount;

  Alternating(this.interventionDuration, this.cycleAmount);

  @override
  int getDuration(List<Intervention> interventions) {
    return interventionDuration * cycleAmount * interventions.length;
  }

  @override
  Intervention? getIntervetionOnDay(int day, List<Intervention> interventions) {
    if (day < 0 || day > getDuration(interventions)) {
      throw ArgumentError(
          "Day must be between 0 and ${getDuration(interventions)}");
    }
    final interventionIndex = day % interventions.length;
    return interventions[interventionIndex];
  }
}


  // factory StudySchedule.fromJson(Map<String, dynamic> json) =>
  //     _$StudyScheduleFromJson(json);
  // Map<String, dynamic> toJson() => _$StudyScheduleToJson(this);

  // int getNumberOfPhases() =>
  //     numberOfCycles * numberOfInterventions + (includeBaseline ? 1 : 0);

  // int get length => getNumberOfPhases() * phaseDuration;

  // List<int> generateWith(int firstIntervention) {
  //   final cycles = Iterable<int>.generate(numberOfCycles);
  //   final phases = cycles
  //       .expand((cycle) => _generateCycle(firstIntervention, cycle))
  //       .toList();
  //   return phases;
  // }

  // int _nextIntervention(int index) => (index + 1) % numberOfInterventions;

  // List<int> _generateCycle(int first, int cycle) {
  //   switch (sequence) {
  //     case PhaseSequence.alternating:
  //       return _generateAlternatingCycle(first, cycle);
  //     case PhaseSequence.counterBalanced:
  //       return _generateCounterBalancedCycle(first, cycle);
  //     case PhaseSequence.randomized:
  //       return _generateRandomizedCycle(first, cycle);
  //     case PhaseSequence.customized:
  //       return _generateCustomizedCycle(cycle);
  //     default:
  //       throw TypeError();
  //   }
  // }

  // List<int> _generateAlternatingCycle(int first, int cycle) =>
  //     [first, _nextIntervention(first)];

  // List<int> _generateCounterBalancedCycle(int first, int cycle) {
  //   final shift = ((cycle + 1) ~/ 2) % 2;
  //   final baseSequence = [first, _nextIntervention(first)];

  //   return shift == 0 ? baseSequence : baseSequence.reversed.toList();
  // }

  // List<int> _generateRandomizedCycle(int first, int cycle) {
  //   final phase = [first, _nextIntervention(first)];
  //   if (cycle > 0) phase.shuffle();
  //   return phase;
  // }

  // List<int> _generateCustomizedCycle(int cycle) {
  //   final String seqNum = sequenceCustom
  //       .replaceAll(RegExp('A', caseSensitive: false), '0')
  //       .replaceAll(RegExp('B', caseSensitive: false), '1');
  //   return seqNum.split('').map(int.parse).toList();
  // }

  // String get nameOfSequence {
  //   switch (sequence) {
  //     case PhaseSequence.alternating:
  //       return 'ABAB';
  //     case PhaseSequence.counterBalanced:
  //       return 'ABBA';
  //     case PhaseSequence.randomized:
  //       return 'Random';
  //     case PhaseSequence.customized:
  //       return 'Custom';
  //   }
  // }

  // @override
  // String toString() {
  //   return 'StudySchedule{numberOfCycles: $numberOfCycles, phaseDuration: $phaseDuration, includeBaseline: $includeBaseline, sequence: $sequence}';
  // }

// enum PhaseSequence {
//   alternating,
//   counterBalanced,
//   randomized,
//   customized;

//   String toJson() => name;

//   static PhaseSequence fromJson(String json) => values.byName(json);
// }

// Schedule
// public blocks: SequenceBlock[]

// interface Block
// type
// duration()

// Baseline extends Block
// type: 'baseline
// duration: int
// diration() -> duration

// Alternating(ABCABC)
// type: 'alternating'
// intervention duration: int
// cycle amount : int
// duration(num_interventions) -> intervention_duration * cycle_amount * num_interventions

// Counterbalanced(ABCCBA)
// type: 'counterbalanced'
// intervention duration: int
// cycle amount : int
// duration(num_interventions) -> intervention_duration * cycle_amount * num_interventions

// Randomized
// type: 'randomized'
// intervention duration: int
// cycle amount : int
// duration(num_interventions) -> intervention_duration * cycle_amount * num_interventions

// Single Intervention
// type: 'single'
// duration: int
// intervention: interventionID
// duration() -> duration

// Adaptive(Thompson Sampling)
// type: 'thompson'
// cycle_amount: int
// intervention_duration: int
// duration() -> intervention_duration * cycle_amount
// decidingQuestion: questionID
