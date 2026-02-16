import 'package:flutter/material.dart';
import 'package:tirono_technologies_flutter_task/src/core/utils/dev_functions/dev_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      child: const Scaffold(body: Center(child: Text('Home Screen'))),
    );
  }
}
