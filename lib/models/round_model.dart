class Round {
  String? answer;
  List<Vote> votes = [];

  Round();

  void setAnswer(String newAnswer) {
    answer = newAnswer;
  }

  void addVote(Vote newVote) {
    votes.add(newVote);
  }

}

class Vote {
  String player;
  String vote;

  Vote({required this.player, required this.vote});
}

class PlayerResults {
  String playerName;
  int points = 0;

  PlayerResults({required this.playerName, required this.points});

  void addPoint() {
    points++;
  }
}