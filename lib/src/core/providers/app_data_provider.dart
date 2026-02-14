import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// App data state
class AppDataState {
  final PackageInfo? packageInformation;
  final bool isInitialized;

  const AppDataState({
    this.packageInformation,
    this.isInitialized = false,
  });

  AppDataState copyWith({
    PackageInfo? packageInformation,
    bool? isInitialized,
  }) {
    return AppDataState(
      packageInformation: packageInformation ?? this.packageInformation,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

/// Handles additional(Optional) app data
/// Optional Data like App Version
class AppDataNotifier extends StateNotifier<AppDataState> {
  AppDataNotifier() : super(const AppDataState());

  /// App data initialing function. This will be called from splash screen
  /// controller
  Future<void> init() async {
    if (state.isInitialized) return;

    final packageInfo = await PackageInfo.fromPlatform();
    
    if (mounted) {
      state = state.copyWith(
        packageInformation: packageInfo,
        isInitialized: true,
      );
    }
  }
}

/// App data provider
final appDataProvider = StateNotifierProvider<AppDataNotifier, AppDataState>(
  (ref) => AppDataNotifier(),
);
