
import 'package:christmas_firestore_app/models/round_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameBaseController extends ChangeNotifier{
  String _url = '';
  bool _showQrCode = false;
  // bool _showQrCode = true;

  String get url => _url;
  bool get showQrCode => _showQrCode;

  List<Round> rounds = [];

  List<PlayerResults> finalResults = [];

  void addRound() {
    rounds.add(Round());
    notifyListeners();
  }

  void addRoundVote(Vote newVote) {
    rounds.last.addVote(newVote);
    notifyListeners();
  }

  void setRoundAnswer(String value) {
    rounds.last.setAnswer(value);
    notifyListeners();
  }

  void generateGameResults() {
    rounds.forEach((round) {
      generateRoundResults(round);
    });
    finalResults.sort((b,a) => a.points.compareTo(b.points));
    finalResults.forEach((item) => print("Result: ${item.playerName} - ${item.points}"));
  }

  void generateRoundResults(Round round) {
    round.votes.forEach((vote) {
      if (round.answer == vote.vote && (vote.player.toLowerCase() != "nem")) {
        int player = finalResults.indexWhere((value) => value.playerName == vote.player);
        if (player != -1) {
          finalResults[player].addPoint();
        } else {
          finalResults.add(PlayerResults(playerName: vote.player, points: 1));
        }
      }
    });
  }

  void setUrl(String value) {
    _url = value;
    notifyListeners();
  }

  void setQrCode(bool value) {
    _showQrCode = value;
    notifyListeners();
  }
  
  int _timerToNextRound = 5;
  int get timerToNextRound => _timerToNextRound;
  bool _timerVisible = false;
  bool get timerVisible => _timerVisible;
  late Function _afterTimerFunction;

  String _playerOne = '';
  String get playerOne => _playerOne;

  void startTimerToNextRound() {
    if (!_timerVisible) {
      _timerVisible = true;
      notifyListeners();
      Future.delayed(Duration(seconds: 1), () {
        decreaseTimer();
      });
    }
  }

  void setAfterTimerFunction(Function function) {
    _afterTimerFunction = function;
  }

  void decreaseTimer() {
    if (_timerToNextRound > 1) {
      _timerToNextRound--;   
      Future.delayed(Duration(seconds: 1), () {
        decreaseTimer();
      });
    } else {
      resetController();
      _afterTimerFunction();
    }
    notifyListeners();
  }

  
  void resetController() {
    _timerToNextRound = 5;
    _timerVisible = false;
    notifyListeners();
  }

}