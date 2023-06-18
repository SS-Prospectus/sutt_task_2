import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sutt_task_2/firebase_options.dart';
import 'package:sutt_task_2/Logic/route_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ProviderScope(
          child: MyApp(),
      ),
    );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.read(userprovider);
    userProvider.initialize();
    return MaterialApp.router(
      title: 'SUTT task 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter().goRouter,
    );
  }
}
