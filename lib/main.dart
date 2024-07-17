import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'router.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  final appRouter = AppRouter();
  const pageTransition = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  runApp(MainApp(appRouter, pageTransition));
}

class MainApp extends StatelessWidget {
  const MainApp(this.appRouter, this.pageTransition, {super.key});

  final AppRouter appRouter;
  final PageTransitionsTheme pageTransition;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nutrition',
      debugShowCheckedModeBanner: false,
      themeAnimationCurve: Curves.easeInOut,
      theme: ThemeData(
        brightness: Brightness.light,
        pageTransitionsTheme: pageTransition,
        colorSchemeSeed: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        pageTransitionsTheme: pageTransition,
        colorSchemeSeed: Colors.red,
      ),
      themeMode: ThemeMode.dark,
      routeInformationParser: appRouter.router.routeInformationParser,
      routeInformationProvider: appRouter.router.routeInformationProvider,
      routerDelegate: appRouter.router.routerDelegate,
    );
  }
}
