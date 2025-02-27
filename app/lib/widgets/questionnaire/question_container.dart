import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:studyu_app/widgets/questionnaire/scale_question_widget.dart';
import 'package:studyu_core/core.dart';

import 'annotated_scale_question_widget.dart';
import 'boolean_question_widget.dart';
import 'choice_question_widget.dart';
import 'question_header.dart';
import 'question_widget.dart';
import 'visual_analogue_question_widget.dart';

class QuestionContainer extends StatefulWidget {
  final Function(Answer, int) onDone;
  final Question question;
  final int index;

  const QuestionContainer({required this.onDone, required this.question, required this.index, super.key});

  @override
  State<StatefulWidget> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> with AutomaticKeepAliveClientMixin {
  void _onDone(Answer answer) {
    widget.onDone(answer, widget.index);
  }

  QuestionWidget? getQuestionBody(BuildContext context) {
    switch (widget.question.runtimeType) {
      case ChoiceQuestion _:
        return ChoiceQuestionWidget(
          question: widget.question as ChoiceQuestion,
          onDone: _onDone,
          multiSelectionText: AppLocalizations.of(context)!.eligible_choice_multi_selection,
        );
      case BooleanQuestion _:
        return BooleanQuestionWidget(
          question: widget.question as BooleanQuestion,
          onDone: _onDone,
        );
      case ScaleQuestion _:
        return ScaleQuestionWidget(
          question: widget.question as ScaleQuestion,
          onDone: _onDone,
        );
      case VisualAnalogueQuestion _:
        // todo remove this when older studies are finished
        // ignore: deprecated_member_use_from_same_package
        return VisualAnalogueQuestionWidget(
          question: widget.question as VisualAnalogueQuestion,
          onDone: _onDone,
        );
      case AnnotatedScaleQuestion _:
        return AnnotatedScaleQuestionWidget(
          question: widget.question as AnnotatedScaleQuestion,
          onDone: _onDone,
        );
      default:
        print('Question not supported!');
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final questionBody = getQuestionBody(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionHeader(
              prompt: widget.question.prompt,
              subtitle: questionBody.subtitle,
              rationale: widget.question.rationale,
            ),
            const SizedBox(height: 24),
            questionBody,
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
