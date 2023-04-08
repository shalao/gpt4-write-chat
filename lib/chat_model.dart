class ChatMessage {
  final String content;
  final String timestamp;

  ChatMessage({required this.content, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'] ?? '',
      timestamp: json['timestamp'],
    );
  }
}
