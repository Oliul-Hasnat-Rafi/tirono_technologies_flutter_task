import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/authentication_provider.dart';
import '../../features/auth/presentation/screens/authentication_wrapper_screen.dart';

import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/patient/presentation/screen/patient_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../providers/auth_provider.dart';

/// Route paths
class AppPaths {
  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';
  static const patient = '/patient';
}

/// Global navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isAuthenticated = authState.authToken != null;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppPaths.splash,
    debugLogDiagnostics: true,
    
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == AppPaths.auth;
      final isSplashRoute = state.matchedLocation == AppPaths.splash;

      if (isSplashRoute) return null;
      if (isAuthenticated && !isAuthRoute && authState.user?.role == UserRole.patient.name) return AppPaths.patient;
      if (isAuthenticated && !isAuthRoute && authState.user?.role == UserRole.doctor.name) return AppPaths.home;
      if (!isAuthenticated && isAuthRoute) return AppPaths.auth;
      
      return null;
    },

    routes: [
      // Splash Screen
      GoRoute(
        path: AppPaths.splash,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          child: const SplashScreen(),
          state: state,
        ),
      ),

      // Authentication
      GoRoute(
        path: AppPaths.auth,
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          child: const AuthenticationWrapperScreen(),
          state: state,
        ),
      ),

      // Home
      GoRoute(
        path: AppPaths.home,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          child:  HomeScreen(),
          state: state,
        ),
      ),

      // Patient
      GoRoute(
        path: AppPaths.patient,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          child:  PatientScreen(),
          state: state,
        ),
      ),


     
    ],
  );
});

/// Fade transition for smooth page changes
CustomTransitionPage _buildPageWithFadeTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

/// Slide transition for modal-like pages
CustomTransitionPage _buildPageWithSlideTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
