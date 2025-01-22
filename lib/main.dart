import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

import 'api/api_client.dart';
import 'api/dio_provider.dart';
import 'api/storage/sqflite.dart';
import 'feature/login.dart';

final apiClientProvider = Provider<ApiClient>((ref){
  final dio = ref.read(dioProvider);
  return ApiClient(dio);
});



void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper binding initializati

  runApp(const ProviderScope(child: MyApp()));  // Wrap the app with ProviderScope for Riverpod.
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutors App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Login(),  // Set the TutorsScreen as the home screen.
    );
  }
}

