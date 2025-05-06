import 'dart:async';
import 'dart:io';

import 'package:developer_options/developer_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class FlutterJailbreakDetectionState {
  static bool _jailbroken = false;
  static bool _developerMode = false;
  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      if (Platform.isAndroid) {
        developerMode = await FlutterJailbreakDetection.developerMode;
      } else if (Platform.isIOS) {
        try {
          DeveloperOptions developerOptions = DeveloperOptions();
          await developerOptions.init();
          developerMode = developerOptions.getDeveloperStatus();
        } catch (e) {
          developerMode = false;
        }
      }
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    _jailbroken = jailbroken;
    _developerMode = developerMode;
  }

  static Future<bool> _isTurnningOnDeveloperMode() async {
    try {
      bool _developerMode = false;
      if (Platform.isAndroid) {
        _developerMode = await FlutterJailbreakDetection.developerMode;
        return _developerMode;
      }
      return _developerMode;
    } on PlatformException {
      _developerMode = true;
      return _developerMode;
    }
  }

  static Future<bool> get isTurnningOnDeveloperMode async =>
      await _isTurnningOnDeveloperMode();
}
