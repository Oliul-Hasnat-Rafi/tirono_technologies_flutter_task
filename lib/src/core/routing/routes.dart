import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

/// Simple navigation extensions using organized paths
extension NavigationExtensions on BuildContext {
  // Go (replace current route)
  void goToSplash() => go(AppPaths.splash);
  void goToAuth() => go(AppPaths.auth);
  void goToHome() => go(AppPaths.home);

  void goToProductDetails(String id) => go('/product/$id');

  // Push (keep in stack)
  void pushToAuth() => push(AppPaths.auth);
  void pushToHome() => push(AppPaths.home);
  void pushToMember() => push(AppPaths.member);
  void pushToPatient() => push(AppPaths.patient);

  void pushToProductDetails(String id) => push('/product/$id');

  // Replace (replace in stack)
  void replaceWithAuth() => replace(AppPaths.auth);
  void replaceWithHome() => replace(AppPaths.home);
}
