import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_game/components/clock_widget.dart';
import 'package:word_game/data_repository/match_repository.dart';
import 'package:word_game/models/letter_model.dart';
import 'package:word_game/providers/clock_provider.dart';
import 'package:word_game/providers/match_provider.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match!"),
        actions: [
          Consumer<MatchProvider>(builder: (context, match, _) {
            if (match.loadingLetters) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.redAccent,
              ));
            } else {
              return IconButton(
                  onPressed: () async {
                    var matchProvider =
                        Provider.of<MatchProvider>(context, listen: false);
                    matchProvider.loadingLetters = true;
                    try {
                      var match = await MatchRepo().createMatch();
                      var matchStarted = await MatchRepo().startMatch(match.id);
                      matchProvider.setLetters(matchStarted.letters, match.id);
                      Provider.of<ClockProvider>(context, listen: false).startClock(60);
                    } catch (error) {
                      print("There was an error starting match");
                    }
                    matchProvider.loadingLetters = false;
                  },
                  icon: const Icon(Icons.add));
            }
          }),
        ],
      ),
      body: Column(
        children: const [
          Flexible(
            child: WordWidget(),
          ),
          Expanded(
            child: LettersWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.width * .8,
                color: Colors.grey[200],
                child: FutureBuilder(
                  future: getWordsInGame(context),
                  builder: (context, AsyncSnapshot snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      print(snapshot.connectionState);
                      print(snapshot.hasData);
                      if(snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Text('${snapshot.data[index]["word"]} - '),
                                Text(snapshot.data[index]["points"].toString()),
                              ],
                            );
                          },
                        );
                      } else {
                        return Text("STILL NO RESULTS");
                      }
                    }
                  },
                ),
              );
            },
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: const ShowTotal(),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<List<dynamic>> getWordsInGame(context) async {
    String matchId = Provider.of<MatchProvider>(context, listen: false).matchId;
    List<dynamic> wordsInGame = [];
    try {
      wordsInGame = await MatchRepo().gameInfo(matchId);
    } catch (e) {
      print(e);
    }
    print("Word: ${wordsInGame[0]["word"]}");
    return wordsInGame;
  }
}

class ShowTotal extends StatelessWidget {
  const ShowTotal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(builder: (_, matchProvider, __) {
      return Center(
          child: Text(
        matchProvider.totalPoints.toString(),
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ));
    });
  }
}

class WordWidget extends StatelessWidget {
  const WordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Letter> word = Provider.of<MatchProvider>(context).word;

    List<Letter> typedWord = [];
    for (int i = 0; i < word.length; i++) {
      typedWord.add(word[i]);
    }
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        color: Colors.grey,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: typedWord.length > 8 ? typedWord.length : 8,
                    children: letterTile(typedWord, false, context),
                  ),
                ),
                Text(
                  "Possible points: ${typedWord.length}",
                  style: const TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          typedWord.isNotEmpty
                              ? Provider.of<MatchProvider>(context, listen: false)
                                  .resetWord()
                              : null;
                        },
                        child: const Icon(Icons.delete_forever)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () {
                          typedWord.isNotEmpty
                              ? checkWord(context, typedWord)
                              : null;
                        },
                        child: const Icon(Icons.check)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                        ),
                        onPressed: () {
                          typedWord.isNotEmpty
                              ? Provider.of<MatchProvider>(context, listen: false)
                                  .removeLastLetter()
                              : null;
                        },
                        child: const Icon(Icons.backspace)),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
                right: 10,
                child: ClockWidget()
            )
          ],
        ));
  }

  Future<void> checkWord(context, List<Letter> typedWord) async {
    const correctSnackBar = SnackBar(content: Text('Good Word!'));
    const wrongSnackBar = SnackBar(content: Text('This word does NOT exist!'));
    String matchId = Provider.of<MatchProvider>(context, listen: false).matchId;
    Map<String, dynamic> result =
        await MatchRepo().validateWord(matchId, typedWord);
    if (result.containsKey('ok')) {
      if (result["ok"]) {
        ScaffoldMessenger.of(context).showSnackBar(correctSnackBar);
        Provider.of<MatchProvider>(context, listen: false).resetWord();
        int actualPoints =
            Provider.of<MatchProvider>(context, listen: false).totalPoints;
        Provider.of<MatchProvider>(context, listen: false).totalPoints =
            actualPoints + result["points"];
        print(result["points"]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(wrongSnackBar);
      }
    } else if (result["error"] != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["error"])));
    }
  }
}



class LettersWidget extends StatelessWidget {
  const LettersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Letter> letters = Provider.of<MatchProvider>(context).letters;
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 8,
              children: letterTile(letters, true, context),
            ),
          ],
        ));
  }
}

List<Widget> letterTile(List<Letter> letters, bool isLetterWidget, context) {
  var lettersProvider = Provider.of<MatchProvider>(context, listen: false);
  List<Widget> widgetsLetter = [];
  for (int i = 0; i < letters.length; i++) {
    bool isUsed = lettersProvider.letters[i].isUsed;
    widgetsLetter.add(
      InkWell(
        onTap: () {
          if (isLetterWidget) {
            if (!isUsed) lettersProvider.addLetter(letters[i]);
          } else {
            lettersProvider.removeLetter(letters[i]);
          }
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: isUsed && isLetterWidget ? Colors.grey : Colors.yellow,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(child: Text(letters[i].letter)),
        ),
      ),
    );
  }
  return widgetsLetter;
}
