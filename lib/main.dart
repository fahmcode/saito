import 'app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saito/core/data/models/user_progress.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserProgressAdapter());
  final box = await Hive.openBox<UserProgress>('user_progress_box');

  runApp(
    BlocProvider(
      create: (context) => UserProgressBloc(box),
      child: const SaitoApp(),
    ),
  );
}
