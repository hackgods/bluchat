class Messages {
  final int? id;
  final String sender;
  final String receiver;
  final String message;
  final String timestamp;

  Messages(
      {this.id, required this.sender, required this.receiver, required this.message, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static Messages fromMap(Map<String, dynamic> map) {
    return Messages(
      id: map['id'],
      sender: map['sender'],
      receiver: map['receiver'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

  Messages copy({int? id, String? message}) {
    return Messages(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp
    );
  }


}
