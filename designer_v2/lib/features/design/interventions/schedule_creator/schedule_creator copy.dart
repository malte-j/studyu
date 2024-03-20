import 'package:flutter/material.dart';
import 'package:studyu_core/core.dart';

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _ReorderableListViewExampleState();
}

const List<String> segmentTypes = <String>['Baseline'];

class _ReorderableListViewExampleState extends State<ReorderableExample> {
  final MP23StudySchedule _schedule = MP23StudySchedule([
    Intervention("intervention1", "Intervention 1"),
    Intervention("intervention2", "Intervention 2"),
  ]);

  String dropdownValue = segmentTypes.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      // set width to 100% of parent
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // list interventions
        // _schedule.interventions.isEmpty
        //     ? const Text("No interventions")
        //     : Column(
        //         children: [
        //           const Text("Interventions:"),
        //           for (final intervention in _schedule.interventions)
        //             Text("${intervention.name} "),
        //         ],
        //       ),
        ReorderableListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          buildDefaultDragHandles: false,
          children: <Widget>[
            for (int i = 0; i < _schedule.segments.length; i++)
              ExpandableSegementItem(
                key: Key(i.toString()),
                index: i,
                segment: _schedule.segments[i],
                interventions: _schedule.interventions,
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              final intervention = _schedule.segments.removeAt(oldIndex);
              _schedule.segments.insert(newIndex, intervention);
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down_sharp),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: segmentTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextButton(
              key: const Key("end"),
              onPressed: () {
                setState(() {
                  if (dropdownValue == "Baseline") {
                    _schedule.segments.add(BaselineScheduleSegment(10));
                  }
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add), // This is the plus icon
                  Text('Add')
                ],
              ),
            ),
          ],
        ),
        Text(
          "Total Duration: ${_schedule.duration} days",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ExpandableSegementItem extends StatefulWidget {
  final int index;
  final StudyScheduleSegment segment;
  final List<Intervention> interventions;

  const ExpandableSegementItem(
      {super.key,
      required this.index,
      required this.segment,
      required this.interventions});

  @override
  createState() => _ExpandableSegementItemState();
}

class _ExpandableSegementItemState extends State<ExpandableSegementItem> {
  @override
  Widget build(BuildContext context) {
    final duration = widget.segment.getDuration(widget.interventions);
    final List<Widget> controls = [const SizedBox(height: 1, width: 20)];

    var segment = widget.segment;

    if (segment is BaselineScheduleSegment) {
      // title
      final durationController =
          TextEditingController(text: segment.duration.toString());

      // text input for duration, change context.schedule.segments[index] duration
      controls.add(TextField(
        controller: durationController,
        onChanged: (value) {
          setState(() {
            segment.duration = int.parse(value);
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Duration',
        ),
      ));
      // } else if (segment is model.Alternating) {
      //   // title
      //   final cycleAmountController =
      //       TextEditingController(text: segment.cycleAmount.toString());

      //   final interventionDurationController =
      //       TextEditingController(text: segment.interventionDuration.toString());

      //   // text input for duration, change context.schedule.segments[index] duration
      //   controls.add(TextField(
      //     controller: cycleAmountController,
      //     onChanged: (value) {
      //       setState(() {
      //         segment.cycleAmount = int.parse(value);
      //       });
      //     },
      //     decoration: const InputDecoration(
      //       border: OutlineInputBorder(),
      //       labelText: 'Cycle Amount',
      //     ),
      //   ));

      //   controls.add(TextField(
      //     controller: interventionDurationController,
      //     onChanged: (value) {
      //       setState(() {
      //         segment.interventionDuration = int.parse(value);
      //       });
      //     },
      //     decoration: const InputDecoration(
      //       border: OutlineInputBorder(),
      //       labelText: 'Intervention Duration',
      //     ),
      //   ));
      // }
    } else {
      throw UnimplementedError("Unknown segment type");
    }

    controls.add(const SizedBox(height: 1, width: 20));

    return ExpansionTile(
      title: Text(widget.segment.name),
      subtitle: Text("Duration: $duration days"),
      leading: ReorderableDragStartListener(
        index: widget.index,
        child: const Icon(Icons.drag_handle),
      ),
      children: [Wrap(runSpacing: 24.0, children: controls)],
    );
  }
}
