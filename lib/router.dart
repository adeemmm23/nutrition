import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition/features/settings/views/profile/profile.dart';

import 'features/ai/ai.dart';
import 'features/camera/camera.dart';
import 'features/home.dart';
import 'features/settings/views/privacy/privacy.dart';
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
          fullscreenDialog: true,
          child: CameraApp(),
        ),
      ),
      GoRoute(
        path: '/ai',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'ai',
          child: AIPage(),
        ),
      ),
      GoRoute(
        path: '/support',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'support',
          child: Support(),
        ),
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'privacy',
          child: Privacy(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'profile',
          child: Profile(),
        ),
      ),
    ],
  );
}
