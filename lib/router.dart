import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrution/features/camera/camera.dart';

import 'features/home.dart';
import 'features/settings/views/support/support.dart';

class AppRouter {
  late final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'home',
          child: Home(),
        ),
      ),
      GoRoute(
        path: '/camera',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'camera',
          child: CameraApp(),
        ),
      ),
      GoRoute(
        path: '/support',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'support',
          child: Support(),
        ),
      ),
    ],
  );
}
