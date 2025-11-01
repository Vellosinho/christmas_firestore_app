import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudflare_test/models/message.dart';
import 'package:cloudflare_test/models/user_model.dart';

class MessageService {

  final FirebaseFirestore _firestore =  FirebaseFirestore.instance;
  
  Future<UserModel> addUser(String userName, int playerModel) async {
    _firestore.collection("Users").doc(playerModel.toString()).set(
      {
        "name": userName,
        "model": playerModel,
      }
    );

    return UserModel(name: userName, playerModel: playerModel);
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        print(user["name"]);
        return user;
      }).toList();
    });
  }

  void sendMessage(String sender, String message) async {
    Message newMessage = Message(content: message, sender: sender);

    await _firestore.collection("Beergame").doc("beergame_votes").collection("messages").add(newMessage.toMap());
  }
}