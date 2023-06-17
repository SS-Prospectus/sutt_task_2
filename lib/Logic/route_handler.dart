import 'package:flutter/material.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'package:go_router/go_router.dart';
import 'package:sutt_task_2/UI/login_email_password.dart';
import 'package:sutt_task_2/UI/signup_email_password.dart';
import 'package:sutt_task_2/UI/home_screen.dart';
import 'package:sutt_task_2/UI/splash_screen.dart';
import 'package:sutt_task_2/UI/phone_screen.dart';
import 'package:sutt_task_2/UI/info_screen.dart';

class AppRouter {
  final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
        ),
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
        ),
        GoRoute(
          path: '/signin',
          pageBuilder: (context, state) => MaterialPage(child: SignupScreen()),
        ),
        GoRoute(
          path: '/phone',
          pageBuilder: (context, state) => MaterialPage(child: PhoneLoginScreen()),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => MaterialPage(child: HomePage()),
        ),
        GoRoute(
          path: '/movie',
          name: 'info',
          pageBuilder: (context, state) => MaterialPage(child: MovieScreen(movie: state.extra as Movie)),
        ),
      ],
  );
  void navigateWithDelay(BuildContext context, String route, Duration delay) {
    Future.delayed(delay, () => context.go(route));
  }
}