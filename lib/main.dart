import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_game/pages/sign_in_page.dart';
import 'package:word_game/pages/users_list.dart';
import 'package:word_game/providers/clock_provider.dart';
import 'package:word_game/providers/match_provider.dart';
import 'package:word_game/services/shared_prefs_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => ClockProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    String result = await getPrefsValue("token");
    setState(() {
      isLogged = !(result == "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLogged
            //? UsersList()
            ? UsersList()
            : SignInPage());
  }
}
