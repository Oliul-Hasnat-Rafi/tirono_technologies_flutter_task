import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/mentor_provider.dart';
import '../../../../core/http/api_end_points.dart';

class MentorScreen extends ConsumerWidget {
  const MentorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mentorState = ref.watch(mentorProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
      ),
      body: mentorState.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) { 
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('${ApiEndPoints.baseUrl}${data[index].user.avatar}'),
              ),
              title: Text(data[index].user.name),
              subtitle: Column(
                children: [
                  Text(data[index].user.email),
                  Text(data[index].professionTitle ?? ''),
                ],
              ),
              
            );
          },
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
