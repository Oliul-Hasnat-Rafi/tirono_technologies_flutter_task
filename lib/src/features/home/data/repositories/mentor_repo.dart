import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/http/http_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/error/failures.dart';
import '../model/mentor_response_model.dart';
import '../../../../core/http/api_end_points.dart';
import 'package:dio/dio.dart' as dio;
class MentorRepository extends HttpRepository {
  MentorRepository({Ref? ref}) : super(ref: ref);

  Future<Result<MentorResponseModel, ServerFailure>> getMentors() async {
    final dio.Response<Map<String, dynamic>> response = await httpClient.get(ApiEndPoints.mentors);
    if (response.statusCode != 200 || response.data == null) {
      return ResultFailure(
        ServerFailure(
          response.data?['message'] ?? 'Failed to get mentors',
          code: response.statusCode,
        ),
      );
    }
    final mentorResponseModel = MentorResponseModel.fromJson(response.data!);
    return Success(mentorResponseModel);
  }
}
