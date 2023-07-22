import 'package:studyu_designer_v2/features/design/enrollment/screener_question_form_controller_mixin.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/controllers/question_form_controller.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/controllers/scale_question_form_controller.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/controllers/bool_question_form_controller.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/controllers/choice_question_form_controller.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/models/bool_question_form_data.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/models/choice_question_form_data.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/models/question_form_data.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/models/scale_question_form_data.dart';
import 'package:studyu_designer_v2/features/design/study_form_validation.dart';

abstract class ScreenerQuestionFormViewModel<D extends QuestionFormData> extends QuestionFormViewModel<D> with ScreenerQuestionFormViewModelMixin {
  static ScreenerQuestionFormViewModel<FD> concrete<FD extends QuestionFormData>({
    FD? formData,
    delegate,
    validationSet = StudyFormValidationSet.draft,
    titles
  }) {
    QuestionFormViewModel ret;
    if (formData == null) {
      ret = ScreenerScaleQuestionFormViewModel(delegate: delegate, validationSet: validationSet, titles: titles);
    } else {
      switch (FD) {
        case BoolQuestionFormData:
          ret = ScreenerBoolQuestionFormViewModel(
            formData: formData as BoolQuestionFormData,
            delegate: delegate,
            validationSet: validationSet,
            titles: titles);
          break;
        case ScaleQuestionFormData:
          ret = ScreenerScaleQuestionFormViewModel(
            formData: formData as ScaleQuestionFormData,
            delegate: delegate,
            validationSet: validationSet,
            titles: titles);
          break;
        case ChoiceQuestionFormData:
          ret = ScreenerChoiceQuestionFormViewModel(
            formData: formData as ChoiceQuestionFormData,
            delegate: delegate,
            validationSet: validationSet,
            titles: titles);
          break;
        default:
          throw UnimplementedError();
      }
    }
    return ret as ScreenerQuestionFormViewModel<FD>;
  }
}

class ScreenerBoolQuestionFormViewModel = BoolQuestionFormViewModel with ScreenerQuestionFormViewModelMixin;
class ScreenerChoiceQuestionFormViewModel = ChoiceQuestionFormViewModel with ScreenerQuestionFormViewModelMixin;
class ScreenerScaleQuestionFormViewModel = ScaleQuestionFormViewModel with ScreenerQuestionFormViewModelMixin;
