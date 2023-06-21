import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';
import 'package:sutt_task_2/UI/fadeanimation.dart';
import 'package:sutt_task_2/UI/hex_color.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:sutt_task_2/Storage and API/secure_storage.dart';
import 'package:sutt_task_2/Storage and API/firebase_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    init();

  }

  Future init() async {
    final state = await UserSecureStorage.getLoggedIn();
    String route = state == 1.toString() ? '/home' : '/login';
    print(state);
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        context.go(route);
      }
    });
    await ref.watch(likedMovieProvider.notifier).update((state) => likedMovies);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xFF03040A),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('lib/assets/Backgroundhome.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          ),
          Container(
          child: Center(
            child: FadeAnimation(
                delay: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("lib/assets/icon.png",
                      height: 200,
                      width: 250,
                    ),
                    Text('Welcome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
            ]
      ),
    );
  }
}


