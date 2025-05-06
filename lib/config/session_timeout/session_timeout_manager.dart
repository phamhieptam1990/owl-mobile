import 'dart:async';

import 'package:flutter/material.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';

import '../../common/constants/general.dart';
import '../../utils/storage/storage_helper.dart';
import 'session_config.dart';

enum SessionState { startListening, stopListening }

class SessionTimeoutManager extends StatefulWidget {
  final SessionConfig _sessionConfig;
  final Widget child;
  final bool enableCheckTimeOut;

  /// (Optional) Used for enabling and disabling the SessionTimeoutManager
  ///
  /// you might want to disable listening, is specific cases as user could be reading, waiting for OTP
  /// where there is no user activity but you don't want to redirect user to login page
  /// in such cases SessionTimeoutManager can be disabled and re-enabled when necessary
  final Stream<SessionState> _sessionStateStream;

  /// Since updating [Timer] fir all user interactions could be expensive, user activity are recorded
  /// only after [userActivityDebounceDuration] interval, by default its 1 minute
  ///
  final Duration userActivityDebounceDuration;
  const SessionTimeoutManager({
    Key? key,
    required SessionConfig sessionConfig,
    required this.child,
    required Stream<SessionState> sessionStateStream,
    this.userActivityDebounceDuration = const Duration(seconds: 10),
    this.enableCheckTimeOut = true,
  })  : _sessionConfig = sessionConfig,
        _sessionStateStream = sessionStateStream,
        super(key: key);

  @override
  _SessionTimeoutManagerState createState() => _SessionTimeoutManagerState();
}

class _SessionTimeoutManagerState extends State<SessionTimeoutManager>
    with WidgetsBindingObserver {
  Timer? _appLostFocusTimer;
  Timer? _userInactivityTimer;
  bool _isListensing = false;

  bool _userTapActivityRecordEnabled = true;

  void _closeAllTimers() {
    if (_isListensing == false) {
      return;
    }

    _clearTimeout(_appLostFocusTimer);
  
    _clearTimeout(_userInactivityTimer);
    if (mounted) {
      setState(() {
        _isListensing = false;
        _userTapActivityRecordEnabled = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget._sessionStateStream.listen((SessionState sessionState) {
      if (sessionState == SessionState.startListening && mounted) {
        setState(() {
          _isListensing = true;
        });

        recordPointerEvent();
      } else if (sessionState == SessionState.stopListening) {
        _closeAllTimers();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!IdieActivity.instance.isLoginPage) {
      StorageHelper.setInt(AppStateConfigConstant.LOGIN_TIME,
          DateTime.now().millisecondsSinceEpoch);
    }

    if (_isListensing == true &&
        (state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused)) {
      _appLostFocusTimer ??= _setTimeout(
        () => widget._sessionConfig.pushAppFocusTimeout(),
        duration: widget._sessionConfig.invalidateSessionForAppLostFocus,
      );
    } else if (state == AppLifecycleState.resumed) {
      _clearTimeout(_appLostFocusTimer);
      _appLostFocusTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Attach Listener only if user wants to invalidate session on user inactivity
    if (_isListensing) {
      return Listener(
        onPointerDown: (_) {
          recordPointerEvent();
        },
        child: widget.child,
      );
    }

    return widget.child;
  }

  void recordPointerEvent() {
    if (_userTapActivityRecordEnabled) {
      _userInactivityTimer?.cancel();
      _userInactivityTimer = _setTimeout(
        () => widget._sessionConfig.pushUserInactivityTimeout(),
        duration: widget._sessionConfig.invalidateSessionForUserInactivity,
      );

      /// lock the button for next [userActivityDebounceDuration] duration
      if (mounted) {
        setState(() {
          _userTapActivityRecordEnabled = false;
        });
      }

      // Enable it after [userActivityDebounceDuration] duration

      Timer(
        widget.userActivityDebounceDuration,
        () {
          if (mounted) {
            setState(() => _userTapActivityRecordEnabled = true);
          }
        },
      );
    }
  }

  Timer? _setTimeout(VoidCallback callback, {required Duration? duration}) {
    if (duration == null) return null;
    return Timer(duration, callback);
  }

  void _clearTimeout(Timer? t) {
    t?.cancel();
  }
}