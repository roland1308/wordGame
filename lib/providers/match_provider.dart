
import 'package:flutter/material.dart';
import 'package:word_game/models/letter_model.dart';

class MatchProvider extends ChangeNotifier {

  List<Letter> _letters = [];
  List<Letter> _word = [];
  String _matchId = "";
  int _totalPoints = 0;

  bool _loadingLetters = false;



  void setLetters(List<String>newLetters, String matchId) {
    _letters = [];
    _word = [];
    _totalPoints = 0;
    _matchId = matchId;
    for (int i=0; i<newLetters.length; i++) {
      _letters.add(Letter(letter:newLetters[i], position: i));
    }
    notifyListeners();
  }

  set totalPoints(value){
    _totalPoints = value;
    notifyListeners();
  }

  set loadingLetters(value){
    _loadingLetters = value;
    notifyListeners();
  }

  get letters => _letters;
  get word => _word;
  get totalPoints => _totalPoints;

  get loadingLetters => _loadingLetters;

  get matchId => _matchId;

  void addLetter(Letter letter){
    _letters[letter.position].isUsed = true;
    _word.add(letter);
    notifyListeners();
  }

  void removeLetter(Letter letter){
    _word.remove(letter);
    _letters[letter.position].isUsed = false;
    notifyListeners();
  }

  void removeLastLetter(){
    var letterRemoved = _word.removeLast();
    _letters[letterRemoved.position].isUsed = false;
    notifyListeners();
  }

  void resetWord(){
    _word = [];
    for (var element in _letters) {element.isUsed=false;}
    notifyListeners();
  }

}