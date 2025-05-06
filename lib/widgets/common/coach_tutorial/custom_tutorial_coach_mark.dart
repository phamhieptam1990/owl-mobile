import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CustomTutorialCoachMark {
  static bool show(
    BuildContext context, {
    List<TargetFocus> targets = const <TargetFocus>[],
    String textSkip = "Bỏ qua",
    VoidCallback? onFinish,
    Function(TargetFocus target)? onClickTarget,
    VoidCallback? onSkip,
    Function(TargetFocus target)? onClickOverlay,
  }) {
    try {
      final tutorialMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        textSkip: textSkip,
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
          onFinish?.call();
        },
        onClickTarget: (target) {
          onClickTarget?.call(target);
        },
        onSkip: () {
          try {
            onSkip?.call();
          } catch (e) {
            debugPrint('Error on skip tutorial coach mark: $e');
          }
          return true;
        },
        onClickOverlay: (target) {
          onClickOverlay?.call(target);
        },
      );

      tutorialMark.show(context: context);
      return true;
    } catch (e) {
      debugPrint('Error showing tutorial coach mark: $e');
      return false;
    }
  }
}