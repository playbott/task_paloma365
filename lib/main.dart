import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_paloma365/bloc/product_bloc.dart';
import 'package:task_paloma365/global.dart';
import 'package:task_paloma365/screens/page_view.dart';
import 'package:task_paloma365/service/sqlite.dart';

import 'bloc/bloc_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDb.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        home: const PageViewScreen(),
      ),
    );
  }
}
