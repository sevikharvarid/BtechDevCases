import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'routes/app_router.dart';

void main() {
  setupDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Btech Dev Cases Mobile',
            routerConfig: appRouter(context), // pass context untuk read Cubit
            theme: ThemeData(primarySwatch: Colors.blue),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}