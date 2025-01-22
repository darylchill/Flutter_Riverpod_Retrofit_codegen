import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/storage/secureStorage.dart';
import '../api/storage/sqflite.dart';
import '../main.dart';

class LoginNotifier extends StateNotifier<AsyncValue<LoginResponse>> {
  final ApiClient apiClient;


  LoginNotifier(this.apiClient) :super(const AsyncLoading());

  // Method to handle login
  Future<LoginResponse> login(String email, String password) async {
    state = const AsyncValue.loading();
    LoginResponse login;

    login = await apiClient.login(User(email: email, password: password));

  //Gonna disable it, its buggy
    //  final userData = {
    //    'username': login.username,
    //    'email': login.email,
    //   'firstname': login.firstname,
    //   'lastname': login.lastname,
    //   'token': login.token,
    //   'date_login': login.date,
    // };

    // final dbHelper = DatabaseHelper.instance;
    // await dbHelper.insertUser(userData);


    // Trim square brackets and double quotes from the API
    String trimmedToken = login.token.replaceAll(RegExp(r'[\[\]"]'), '');
    // After login, save token for future requests
    await TokenStorage.saveToken(trimmedToken); // Save token securely

    return login;

  }

// Method to handle logout
Future<String> logout() async {
  state = const AsyncValue.loading();
  String logout = "";


  logout = await apiClient.logout();
  String logoutMessage = logout.replaceAll(RegExp(r'[\[\]"]'), '');

  return logoutMessage;

}
}

// Provider for LoginNotifier
final loginNotifierProvider = StateNotifierProvider<LoginNotifier, AsyncValue<LoginResponse>>((ref) {
  final apiClient = ref.read(apiClientProvider); // Use the ApiClient provider
  return LoginNotifier(apiClient);
});