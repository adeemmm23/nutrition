import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrution/features/camera.dart';

import 'features/home.dart';

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
    ],
  );
}
