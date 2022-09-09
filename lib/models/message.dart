// message model

class Message {
  final String? messageText;
  final String? senderId;
  final String? name;
  final String? date;

  Message({this.messageText, this.senderId, this.name, this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageText: json['message'],
      senderId: json['senderId'],
      name: json['name'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': messageText,
      'senderId': senderId,
      'name': name,
      'date': date,
    };
  }
}