import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/log_in/login_form.dart';
import 'package:flutter_hbm/screens/main_page.dart';
import 'package:flutter_hbm/screens/provider/date_provider.dart';
import 'package:flutter_hbm/screens/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isLoading = true;
  Widget initialScreen = LoginForm();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await checkUserAuthentication();
    });
  }

  Future<void> checkUserAuthentication() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authentication_token');

    if (token != null && token.isNotEmpty) {
      bool isValid = await validateToken(token);
      if (isValid) {
        await userProvider.loadUserProfile(false);
        await userProvider.loadFoodIntakes(DateTime.now().toIso8601String().split("T")[0]);
        await userProvider.loadExerciseData(DateTime.now().toIso8601String().split("T")[0]);
        await userProvider.loadProfilePicture();
        await userProvider.loadNotifications();
        setState(() {
          initialScreen = MainPage();
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> validateToken(String token) async {
    try {
      List<String> tokenParts = token.split('.');
      if (tokenParts.length != 3) {
        return false;
      }

      String payload = tokenParts[1];
      String normalizedPayload = base64.normalize(payload);
      String decodedPayload = utf8.decode(base64.decode(normalizedPayload));
      Map<String, dynamic> payloadMap = json.decode(decodedPayload);

      int expInSeconds = payloadMap['exp'];
      int currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      return currentTimeInSeconds < expInSeconds;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Body&Mind',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: isLoading ? const Scaffold(body: Center(child: CircularProgressIndicator())) : initialScreen,
    );
  }
}