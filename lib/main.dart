// ignore_for_file: deprecated_member_use
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:sutt_task_2/firebase_options.dart';
import 'package:sutt_task_2/Logic/route_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';
import 'package:sutt_task_2/Storage and API/firebase_storage.dart';
import 'main.data.dart';
import 'Storage and API/api_services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getLikedMovies();
  runApp(
      ProviderScope(
        overrides: [
          configureRepositoryLocalStorage(),
        ],
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => MyApp(),
        ),
      ),
    );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});// This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.read(userprovider);
    userProvider.initialize();
    checkNetworkAvailability(ref);

    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'SUTT task 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      routerConfig: AppRouter().goRouter,
    );
  }
}
