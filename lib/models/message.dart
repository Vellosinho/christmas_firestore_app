class Message {
  final String sender;
  final String content;

  Message({required this.sender, required this.content});

  Map<String, String> toMap() {
    return {
      'sender': sender,
      'content': content,
    };
  }
}