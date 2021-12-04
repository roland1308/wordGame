
import 'package:flutter/material.dart';
import 'package:word_game/pages/match_page.dart';
import 'package:word_game/pages/sign_in_page.dart';
import 'package:word_game/services/shared_prefs_service.dart';

class DrawerWords extends StatelessWidget {
  const DrawerWords({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            onTap: () {
              clearPrefs();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInPage(),
                  ),
                      (route) => false);
            },
            leading: const Icon(Icons.logout),
            title: const Text("Log out", style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MatchPage(),
                  ),
                      (route) => false);
            },
            leading: const Icon(Icons.videogame_asset_outlined),
            title: const Text("Start Match", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}