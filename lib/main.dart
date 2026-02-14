import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/providers/theme_provider.dart';
import 'src/core/environment/environment.dart';
import 'src/core/theme/app_theme.dart';

void main(List<String> args) async {
  //? This line is important for initializing the app
  WidgetsFlutterBinding.ensureInitialized();

  //! ------------------------------------------------ App supported orientation
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  //! -------------------------------------------- Loading pre-initializing data
  await Environment.init; // Initialize environment

  Widget app = ScreenUtilInit(
    fontSizeResolver: (num fontSize, _) => fontSize.toDouble(),
    ensureScreenSize: true,
    designSize: defaultBaseScreenSize,
    minTextAdapt: true,
    useInheritedMediaQuery: true,
    splitScreenMode: true,
    builder: (BuildContext context, Widget? child) => const ProviderScope(
      child: _MyApp(),
    ),
  );
  runApp(DevicePreview(enabled: !kReleaseMode, builder: (_) => app));
}

class _MyApp extends ConsumerWidget {
  const _MyApp();

   @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme provider for reactive updates
    final themeState = ref.watch(themeProvider);
    
    // Watch router for reactive navigation
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.theme(context),
      darkTheme: AppTheme.theme(context, brightness: Brightness.dark),
      themeMode: themeState.themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      builder: (BuildContext context, Widget? child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.setSafeAreaColor(context),
          child: child!,
        );
      },
    );
  }
}
