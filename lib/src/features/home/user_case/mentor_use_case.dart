import '../data/repositories/mentor_repo.dart';
import '../../../core/result/result.dart';
import '../../../core/error/failures.dart';
import '../data/model/mentor_response_model.dart';
class MentorUseCase {
  final MentorRepository mentorRepository;
  MentorUseCase({required this.mentorRepository});
  Future<Result<MentorResponseModel, ServerFailure>> getMentors() async {
    return await mentorRepository.getMentors();
  }
}