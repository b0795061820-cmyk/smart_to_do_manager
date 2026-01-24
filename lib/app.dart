import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/task_repository.dart';
import 'providers/task_provider.dart';
import 'ui/screens/home_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(create: (_) => TaskRepository()),
        ChangeNotifierProvider<TaskProvider>(
          create: (ctx) => TaskProvider(ctx.read<TaskRepository>())..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const HomeScreen(),
      ),
    );
  }
}
