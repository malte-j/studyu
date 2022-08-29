import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_designer_v2/features/design/shared/questionnaire/question/question_form_controller.dart';
import 'package:studyu_designer_v2/features/design/study_form_validation.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';

class ScreenerQuestionFormViewModel extends QuestionFormViewModel {
  ScreenerQuestionFormViewModel({
    super.formData,
    super.delegate,
    super.validationSet = StudyFormValidationSet.draft,
    super.titles,
  }) {
    // Make sure form is initialized with base controls override
    markFormGroupChanged();
  }

  late final FormArray responseOptionsDisabledArray =
      FormArray(_copyFormControls(answerOptionsArray.controls), disabled: true);
  late final FormArray<bool> responseOptionsLogicControls = FormArray(
    List.generate(answerOptionsArray.controls.length, (index) => FormControl()),
  );
  late final FormArray<String> responseOptionsLogicDescriptionControls =
      FormArray(
    List.generate(answerOptionsArray.controls.length, (index) => FormControl()),
  );

  List<AbstractControl> get responseOptionsDisabledControls =>
      responseOptionsDisabledArray.controls;

  final List<FormControlOption<bool>> logicControlOptions = [
    FormControlOption(true, "Qualify".hardcoded),
    FormControlOption(false, "Disqualify".hardcoded)
  ];

  @override
  late final Map<String, AbstractControl> questionBaseControls = {
    ...super.questionBaseControls,
    'responseOptionLogic': responseOptionsLogicControls,
    'responseOptionLogicDescriptions': responseOptionsLogicDescriptionControls,
  };

  List<AbstractControl> prevResponseOptionControls = [];

  @override
  onResponseOptionsChanged(List<AbstractControl> responseOptionControls) {
    // Build new form arrays consolidated with previous values (if any)
    final newLogicControls = responseOptionControls.map((newControl) {
      // Consolidate with previous value (if any)
      final idx = prevResponseOptionControls.indexOf(newControl);
      final newValue = (idx != -1)
          ? responseOptionsLogicControls.controls[idx].value
          : null;
      return FormControl<bool>(value: newValue);
    }).toList();
    final newLogicDescriptionControls = responseOptionControls.map((newControl) {
      // Consolidate with previous value (if any)
      final idx = prevResponseOptionControls.indexOf(newControl);
      final newValue = (idx != -1)
          ? responseOptionsLogicDescriptionControls.controls[idx].value
          : null;
      return FormControl<String>(value: newValue);
    }).toList();
    final newResponseOptionsControls = _copyFormControls(responseOptionControls);

    // Keep disabled controls in sync with actual response option controls
    responseOptionsDisabledArray.clear();
    responseOptionsDisabledArray.addAll(newResponseOptionsControls);
    responseOptionsDisabledArray.markAsDisabled();

    // Reset logic controls to new consolidated ones
    responseOptionsLogicControls.clear();
    responseOptionsLogicControls.addAll(newLogicControls);
    //responseOptionsLogicDescriptionControls.clear();
    //responseOptionsLogicDescriptionControls.addAll(newLogicDescriptionControls);

    prevResponseOptionControls = responseOptionControls;
  }

  List<FormControl> _copyFormControls(List<AbstractControl> controls) {
    return controls
        .map((control) => FormControl<String>(value: control.value.toString()))
        .toList();
  }
}
