class Message {
  final String id;
  final String senderId;
  final String content;
  final String type;
  final DateTime? timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> data, String id) {
    return Message(
      id: id,
      senderId: data['senderId'],
      content: data['content'],
      type: data['type'],
      timestamp: data['timestamp']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'type': type,
      'timestamp': timestamp,
    };
  }
}