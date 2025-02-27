import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studyu_app/util/cache.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_flutter_common/studyu_flutter_common.dart';

import '../../../models/app_state.dart';
import '../../../routes.dart';

class KickoffScreen extends StatefulWidget {
  const KickoffScreen({super.key});

  @override
  State<KickoffScreen> createState() => _KickoffScreen();
}

class _KickoffScreen extends State<KickoffScreen> {
  StudySubject? subject;
  bool ready = false;

  Future<void> _storeUserStudy(BuildContext context) async {
    try {
      // Start study at the next day
      final now = DateTime.now();
      subject!.startedAt = DateTime(now.year, now.month, now.day + 1).toUtc();
      subject = await subject!.save();
      if (!mounted) return;
      context.read<AppState>().activeSubject = subject;
      context.read<AppState>().init(context);
      await Cache.storeSubject(context.read<AppState>().activeSubject);
      await storeActiveSubjectId(subject!.id);
      if (!mounted) return;
      setState(() => ready = true);
      Navigator.pushNamedAndRemoveUntil(context, Routes.dashboard, (_) => false);
    } catch (e) {
      print('Failed creating subject: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    subject = context.read<AppState>().activeSubject;
    _storeUserStudy(context);
  }

  Widget _constructStatusIcon(BuildContext context) => !ready
      ? const SizedBox(
          height: 64,
          width: 64,
          child: CircularProgressIndicator(),
        )
      : Icon(
          MdiIcons.checkboxMarkedCircle,
          color: Colors.green,
          size: 64,
        );

  String _getStatusText(BuildContext context) =>
      !ready ? AppLocalizations.of(context)!.setting_up_study : AppLocalizations.of(context)!.good_to_go;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject!.study.title!),
        leading: Icon(MdiIcons.fromString(subject!.study.iconName)),
      ),
      body: Builder(
        builder: (buildContext) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _constructStatusIcon(context),
                    const SizedBox(height: 32),
                    Text(
                      _getStatusText(context),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _storeUserStudy(context),
                      child: Text(AppLocalizations.of(context)!.start_study),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
