import 'mentor_model.dart';

class MentorResponseModel {

  final List<MentorModel> data;

  const MentorResponseModel({

    required this.data,
  });

  factory MentorResponseModel.fromJson(Map<String, dynamic> json) {
    return MentorResponseModel(

      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MentorModel.fromJson(e))
          .toList(),
    );
  }
}
