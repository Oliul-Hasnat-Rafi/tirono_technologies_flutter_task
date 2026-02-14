import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/data/model/mentor_model.dart';
import '../../../../core/result/result.dart';
import '../../user_case/mentor_use_case.dart';
import '../../data/repositories/mentor_repo.dart';

// class MentorProviderState {
//   final bool isLoading;
//   final ServerFailure? error;
//   final List<MentorModel> mentors;

//   const MentorProviderState({
//     this.isLoading = false,
//     this.error,
//     this.mentors = const [],
//   });

//   MentorProviderState copyWith({
//     bool? isLoading,
//     ServerFailure? error,
//     List<MentorModel>? mentors,
//   }) {
//     return MentorProviderState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//       mentors: mentors ?? this.mentors,
//     );
//   }
// }

class MentorProviderNotifier
    extends StateNotifier<AsyncValue<List<MentorModel>>> {
  final MentorUseCase mentorUseCase;

  MentorProviderNotifier({required this.mentorUseCase})
      : super(const AsyncValue.loading());

  Future<void> getMentors() async {
    state = const AsyncValue.loading();

    final result = await mentorUseCase.getMentors();

    if (result case Success(:final data)) {
      state = AsyncValue.data(data.data);
    } else {
      state = AsyncValue.error(
          result.failureOrNull ?? 'Unknown error', StackTrace.current);
    }
  }
}

final mentorProvider = StateNotifierProvider.autoDispose<MentorProviderNotifier,
    AsyncValue<List<MentorModel>>>((ref) {
  final notifier = MentorProviderNotifier(
      mentorUseCase:
          MentorUseCase(mentorRepository: MentorRepository(ref: ref)));
  notifier.getMentors();
  return notifier;
});
