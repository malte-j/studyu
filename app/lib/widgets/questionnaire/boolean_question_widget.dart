import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:studyu_core/core.dart';

import '../selectable_button.dart';
import 'question_widget.dart';

class BooleanQuestionWidget extends QuestionWidget {
  final BooleanQuestion question;
  final Function(Answer)? onDone;

  const BooleanQuestionWidget({super.key, required this.question, this.onDone});

  @override
  State<BooleanQuestionWidget> createState() => _BooleanQuestionWidgetState();
}

class _BooleanQuestionWidgetState extends State<BooleanQuestionWidget> {
  bool? selected;

  @override
  void initState() {
    super.initState();
    selected = null;
  }

  void tapped({bool? choice}) {
    setState(() {
      selected = choice;
      widget.onDone!(widget.question.constructAnswer(selected!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableButton(
          selected: selected == true,
          onTap: () => tapped(choice: true),
          child: Text(AppLocalizations.of(context)!.yes),
        ),
        const SizedBox(height: 8),
        SelectableButton(
          selected: selected == false,
          onTap: () => tapped(choice: false),
          child: Text(AppLocalizations.of(context)!.no),
        ),
      ],
    );
  }
}
