import 'package:firebase_database/firebase_database.dart';

class MessagingRepository {
  final DatabaseReference _databasePlayerReference = FirebaseDatabase.instance.ref().child('players');
  final DatabaseReference _databaseAdminReference = FirebaseDatabase.instance.ref().child('admin');
  final DatabaseReference _databaseOptionsReference = FirebaseDatabase.instance.ref().child('options');
  final DatabaseReference _databaseEventsReference = FirebaseDatabase.instance.ref().child('events');
  final DatabaseReference _databaseRoundsReference = FirebaseDatabase.instance.ref().child('rounds');
  DatabaseReference get databaseEventsReference => _databaseEventsReference;
  final Query _databasePlayerReferenceQuery = FirebaseDatabase.instance.ref().child('players');
  final Query _databaseAdminReferenceQuery = FirebaseDatabase.instance.ref().child('admin');
  final Query _databaseOptionsReferenceQuery = FirebaseDatabase.instance.ref().child('options');
  final Query _databaseEventsReferenceQuery = FirebaseDatabase.instance.ref().child('events');
  Query get databasePlayerReferenceQuery => _databasePlayerReferenceQuery;
  Query get databaseAdminReferenceQuery => _databaseAdminReferenceQuery;
  Query get databaseOptionsReferenceQuery => _databaseOptionsReferenceQuery;
  Query get databaseEventsReferenceQuery => _databaseEventsReferenceQuery;

  void addUser(String name, List<String> votes) {
    if (name.toLowerCase() == 'nem') {
      addAdmin(name, votes);
    } else {
      addPlayer(name, votes);
    }
  }

  void addPlayer(String name, List<String> votes) {
    Map<String, dynamic> user = {
      'userName': name,
      'role': (name.toLowerCase() == 'nem') ? 'admin' : 'player',
      'votes': votes,
    };

    _databasePlayerReference.push().set(user);
  }

  void addAdmin(String name, List<String> votes) {
    Map<String, dynamic> user = {
      'userName': name,
      'role': (name.toLowerCase() == 'nem') ? 'admin' : 'player',
      'votes': votes,
    };

    _databaseAdminReference.push().set(user);
  }

  void adminAddOptions(String name) {
    Map<String, dynamic> opt = {
      "option": name
    };

    _databaseOptionsReference.push().set(opt);
  }

  void setAnswer(String userName, String answer, int round) {
    Map<String, dynamic> opt = {
      "userName": userName,
      "answer": answer
    };

    _databaseRoundsReference.child('round_$round').push().set(opt);
  }

  void addEvent(String latestEvent, int roundnum) {
    Map<String, dynamic> event = {
      "event": latestEvent,
      "roundnum": roundnum
    };

    _databaseEventsReference.push().set(event);
  }
  
  void cleanGame() {
    cleanEvents();
    cleanRounds();
    cleanPlayers();
    cleanAdmins();
  }
  void cleanEvents() {
    _databaseEventsReference.set({});
  }
  void cleanRounds() {
    _databaseRoundsReference.set({});
  }
  void cleanPlayers() {
    _databasePlayerReference.set({});
  }
  void cleanAdmins() {
    _databaseAdminReference.set({});
  }
}