import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer_v2/constants.dart';
import 'package:studyu_designer_v2/features/design/interventions/intervention_form_controller.dart';
import 'package:studyu_designer_v2/features/design/interventions/intervention_form_data.dart';
import 'package:studyu_designer_v2/features/design/interventions/interventions_form_data.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model_collection.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model_collection_actions.dart';
import 'package:studyu_designer_v2/repositories/api_client.dart';
import 'package:studyu_designer_v2/routing/router_config.dart';
import 'package:studyu_designer_v2/routing/router_intent.dart';
import 'package:studyu_designer_v2/utils/extensions.dart';
import 'package:studyu_designer_v2/utils/model_action.dart';
import 'package:studyu_designer_v2/utils/riverpod.dart';

class InterventionsFormViewModel extends FormViewModel<InterventionsFormData>
    implements
        IFormViewModelDelegate<InterventionFormViewModel>,
        IListActionProvider<InterventionFormViewModel>,
        IProviderArgsResolver<InterventionFormViewModel,
            InterventionFormRouteArgs> {
  InterventionsFormViewModel({
    required this.study,
    required this.router,
    super.delegate,
    super.formData,
    super.autosave = true,
  });

  final Study study;
  final GoRouter router;

  // - Form fields

  final FormArray interventionsArray =
      FormArray([], validators: [Validators.minLength(1)]);
  late final interventionsCollection = FormViewModelCollection<
      InterventionFormViewModel, InterventionFormData>([], interventionsArray);

  @override
  late final FormGroup form = FormGroup({
    'interventions': interventionsArray,
    // TODO: phase schedule
  });

  @override
  void setControlsFrom(InterventionsFormData data) {
    final viewModels = data.interventionsData
        .map((data) => InterventionFormViewModel(
            study: study, formData: data, delegate: this))
        .toList();
    interventionsCollection.reset(viewModels);
  }

  @override
  InterventionsFormData buildFormData() {
    return InterventionsFormData(
      interventionsData: interventionsCollection.formData,
    );
  }

  @override
  Map<FormMode, String> get titles => throw UnimplementedError(); // no title

  // - IListActionProvider

  @override
  List<ModelAction> availableActions(InterventionFormViewModel model) {
    // TODO: set & propagate FormMode.readonly at root FormViewModel (if needed)
    final isReadonly = formMode == FormMode.readonly;
    final actions = interventionsCollection.availableActions(model, onEdit: onSelectItem, isReadOnly: isReadonly);
    return withIcons(actions, modelActionIcons);
  }

  List<ModelAction> availablePopupActions(
      InterventionFormViewModel model) {
    final actions = interventionsCollection.availablePopupActions(model);
    return withIcons(actions, modelActionIcons);
  }

  List<ModelAction> availableInlineActions(
      InterventionFormViewModel model) {
    final actions = interventionsCollection.availableInlineActions(model);
    return withIcons(actions, modelActionIcons);
  }

  @override
  void onSelectItem(InterventionFormViewModel item) {
    final studyId = study.id;
    final interventionId = item.interventionId;
    router
        .dispatch(RoutingIntents.studyEditIntervention(studyId, interventionId));
  }

  @override
  void onNewItem() {
    final studyId = study.id;
    router.dispatch(
        RoutingIntents.studyEditIntervention(studyId, Config.newModelId));
  }

  // - IProviderArgsResolver

  // TODO: factor this out into FormViewModelCollection
  @override
  InterventionFormViewModel provide(InterventionFormRouteArgs args) {
    if (args.interventionId.isNewId) {
      // Eagerly add the managed viewmodel in case it needs to be [provide]d
      // to a child controller
      final viewModel = InterventionFormViewModel(
          study: study, formData: null, delegate: this);
      interventionsCollection.stage(viewModel);
      return viewModel;
    }

    final viewModel = interventionsCollection
        .findWhere((vm) => vm.interventionId == args.interventionId);
    if (viewModel == null) {
      throw InterventionNotFoundException(); // TODO handle 404 not found
    }
    return viewModel;
  }

  // - IFormViewModelDelegate

  @override
  void onCancel(
      InterventionFormViewModel formViewModel, FormMode formMode) {
    return; // no-op
  }

  @override
  void onSave(
      InterventionFormViewModel formViewModel, FormMode prevFormMode) {
    if (prevFormMode == FormMode.create) {
      // Commit the managed viewmodel that was eagerly added in [provide]
      interventionsCollection.commit(formViewModel);
    } else if (prevFormMode == FormMode.edit) {
      // nothing to do here
    }
    super.save();
  }
}
