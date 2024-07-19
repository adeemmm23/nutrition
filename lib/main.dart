import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/state/color_bloc.dart';
import 'global/state/theme_bloc.dart';
import 'router.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  final appRouter = AppRouter();
  final prefs = await SharedPreferences.getInstance();

  final theme = prefs.getInt('theme') ?? 0;
  final themeCubit = ThemeCubit(theme);

  final color = prefs.getInt('color') ?? 0;
  final colorCubit = ColorCubit(color);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(MainApp(
    appRouter,
    themeCubit,
    colorCubit,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp(
    this.appRouter,
    this.themeCubit,
    this.colorCubit, {
    super.key,
  });

  final ThemeCubit themeCubit;
  final ColorCubit colorCubit;
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    const pageTransition = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: colorCubit),
      ],
      child: BlocBuilder<ColorCubit, Color>(
        builder: (context, color) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Nutrition Guide',
              debugShowCheckedModeBanner: false,
              themeAnimationCurve: Curves.easeInOut,
              theme: ThemeData(
                brightness: Brightness.light,
                pageTransitionsTheme: pageTransition,
                colorSchemeSeed: color,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                pageTransitionsTheme: pageTransition,
                colorSchemeSeed: color,
              ),
              themeMode: themeMode,
              routeInformationParser: appRouter.router.routeInformationParser,
              routeInformationProvider:
                  appRouter.router.routeInformationProvider,
              routerDelegate: appRouter.router.routerDelegate,
            );
          });
        },
      ),
    );
  }
}
