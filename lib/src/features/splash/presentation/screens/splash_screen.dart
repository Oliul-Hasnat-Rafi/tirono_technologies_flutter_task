import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../components.dart';
import '../../../../core/providers/app_data_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/values/app_assets.dart';
import '../providers/splash_provider.dart';
import '../../../../core/utils/dev_functions/dev_scaffold.dart';
import '../../../../widgets/loading_bar.dart';
import '../../../../widgets/svg.dart';
import '../../../../widgets/text.dart';

/// Splash Screen
class SplashScreen extends ConsumerStatefulWidget {
  /// Splash Screen
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    // Initialize splash screen once
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() {
        ref.read(splashScreenProvider.notifier).init();
      });
    }

    // Listen for navigation changes
    ref.listen<SplashScreenState>(splashScreenProvider, (previous, next) {
      if (next.canNavigate) {
        final notifier = ref.read(splashScreenProvider.notifier);
        if (notifier.isAuthenticated) {
          context.go(AppPaths.home);
        } else {
          context.go(AppPaths.auth);
        }
      }
    });

    return DevScaffold(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: const Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _AppDetails(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _AppStatus(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDetails extends StatelessWidget {
  const _AppDetails();

  final TextAlign textAlign = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Logo
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: theme.buttonTheme.height * 4),
            child: const AspectRatio(
              aspectRatio: 1,
              child:  CustomSVG(
                AppAssets.logo,
              //  color: color,
              ),
            ),
          ),
          SizedBox(height: defaultPadding / 2),

          // Heading
          CustomTextHeading.S(
            text: appName,
            textAlign: textAlign,
            isBold: true,
            color: color,
          ),
          SizedBox(height: defaultPadding / 4),

          // Subheading
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: defaultMaxBoxWidth,
            ),
            child: CustomTextBody(
              text: appDescription,
              textAlign: textAlign,
              isBold: true,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppStatus extends ConsumerWidget {
  const _AppStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color color = colorScheme.primary;
    final appDataState = ref.watch(appDataProvider);
    final PackageInfo? packageInfo = appDataState.packageInformation;
    final String appVersion = packageInfo?.version ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomCircularProgressBar(color: color),
        SizedBox(height: defaultPadding / 2),
        if (appVersion.isNotEmpty)
          CustomTextBody.S(
            text: 'Version: $appVersion',
            isBold: true,
            color: color,
          ),
      ],
    );
  }
}
