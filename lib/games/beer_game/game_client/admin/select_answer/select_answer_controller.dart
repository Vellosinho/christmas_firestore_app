
import 'dart:ui';

import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectAnswerController extends ChangeNotifier{
  String _selectedAnswer = '';
  String get selectedAnswer => _selectedAnswer;

  int _lastRoundVoted = -1;
  int get lastRoundVoted => _lastRoundVoted;

  int _timerToNextRound = 5;
  int get timerToNextRound => _timerToNextRound;
  bool _timerVisible = false;
  bool get timerVisible => _timerVisible;
  late Function _afterTimerFunction;
    String _playerName = '';
  bool _playerReady = false;
  
  String get playerName => _playerName;
  bool get playerReady => _playerReady;

  bool get isNem => _playerName.toLowerCase() == 'nem';

  Color _screenBackgroundColor = PlayerColors.noPlayerBaseColor;
  Color get screenBackgroundColor => _screenBackgroundColor;

  void setBackgroundColor(Color newColor) {
    _screenBackgroundColor = newColor;
    notifyListeners();
  }
  

  void setPlayerName(String value) {
    _playerName = value;
    notifyListeners();
  }

  void setPlayerReady(bool value) {
    _playerReady = value;
    notifyListeners();
  }

  Future<void> saveSessionLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', _playerName);
    await prefs.setBool('playerReady', _playerReady);
    await prefs.setInt('lastVotedRound', _lastRoundVoted);
  }

  Future<void> getSessionLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    _playerName = prefs.getString('playerName') ?? '';
    _lastRoundVoted = prefs.getInt('lastVotedRound') ?? -1;
    _playerReady = prefs.getBool('playerReady') ?? false;
    notifyListeners();
  }
 

  void setSelectedAnswer(String value) {
    _selectedAnswer = value;
    notifyListeners();
  }

  void setAnsweredToRound(int value) {
    _lastRoundVoted = value;
    notifyListeners();
  }

  void startTimerToNextRound() {
    if (!_timerVisible) {
      _timerVisible = true;
      notifyListeners();
      Future.delayed(Duration(seconds: 1), () {
        decreaseTimer();
      });
      notifyListeners();
    }
  }

  void setAfterTimerFunction(Function function) {
    _afterTimerFunction = function;
    notifyListeners();
  }

  void decreaseTimer() {
    if (_timerToNextRound > 1) {
      _timerToNextRound--;   
      Future.delayed(Duration(seconds: 1), () {
        decreaseTimer();
      });
    } else {
      _afterTimerFunction();
      resetController();
    }
    notifyListeners();
  }

  void resetController() {
    _selectedAnswer = '';
    _timerToNextRound = 5;
    _timerVisible = false;
    notifyListeners();
  }

}