import 'package:flutter/material.dart';
import 'package:word_game/components/drawer_words.dart';
import 'package:word_game/data_repository/users_repository.dart';
import 'package:word_game/models/user_model.dart';

import '../services/location_manager.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isLoaded = false;
  bool hasError = false;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    LocationManager().updateUserPosition();
    getData();
  }

  Future<void> getData() async {
    try {
      users = await UsersRepo().getUsers();
    } catch (e) {
      hasError = true;
      print("Error loading users $e");
    } finally {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWords(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Current Users"),
        ),
        body: isLoaded
            ? Container(
                child: hasError
                    ? const Text("Error loading data")
                    : RefreshIndicator(
                        onRefresh: getData,
                        child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(users[index].email),
                                  subtitle: users[index].position != null
                                      ? Text(
                                          "${users[index].position?.lat} / ${users[index].position?.lng}")
                                      : const Text("User not located"));
                            }),
                      ))
            : const Center(child: CircularProgressIndicator()));
  }
}
