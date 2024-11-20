import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:sap_avicola/repositories/auth_api.dart';
import 'package:sap_avicola/utils/config/router_config.dart';

class SessionTimeoutConfig {
  SessionTimeoutConfig(this.context);
  final BuildContext context;

  late final authApi = AuthApi(context);

  final instance = SessionConfig(
      // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
      // invalidateSessionForUserInactivity: const Duration(seconds: 30),
      );

  void listen() => instance.stream.listen((timeoutEvent) {
        if (!router.requireAuth) return;

        switch (timeoutEvent) {
          case SessionTimeoutState.userInactivityTimeout:
            // * handle user  inactive timeout
            authApi.signOut();
            break;

          case SessionTimeoutState.appFocusTimeout:
            // * handle user  app lost focus timeout
            authApi.signOut();
            break;
        }
      });

  void dispose() => instance.dispose();
}
