import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMeta {
  final String chatID;
  final String senderID;
  final String receiverID;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isLastMessageRead;
  final String otherUserID;
  final List<String> participants;

  ChatMeta({
    required this.chatID,
    required this.senderID,
    required this.receiverID,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isLastMessageRead,
    required this.otherUserID,
    required this.participants,
  });

  Map<String, dynamic> toJson() => {
        'chatID': chatID,
        'senderID': senderID,
        'receiverID': receiverID,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime?.toUtc(),
        'isLastMessageRead': isLastMessageRead,
        'otherUserID': otherUserID,
        'participants': participants,
      };

  factory ChatMeta.fromJson(Map<String, dynamic> json) {
    final ts = json['lastMessageTime'];
    DateTime? time;
    if (ts is DateTime) {
      time = ts;
    } else if (ts is Timestamp) {
      time = ts.toDate();
    } else if (ts is String) {
      time = DateTime.tryParse(ts);
    }
    return ChatMeta(
      chatID: json['chatID'] as String? ?? '',
      senderID: json['senderID'] as String? ?? '',
      receiverID: json['receiverID'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: time,
      isLastMessageRead: json['isLastMessageRead'] as bool? ?? false,
      otherUserID: json['otherUserID'] as String? ?? '',
      participants: (json['participants'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
    );
  }
}

class MessageModel {
  final String messageID;
  final String message;
  final String messageType;
  final String senderID;
  final String receiverID;
  final bool seen;
  final DateTime createdAt;

  MessageModel({
    required this.messageID,
    required this.message,
    required this.messageType,
    required this.senderID,
    required this.receiverID,
    required this.seen,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'messageID': messageID,
        'message': message,
        'messageType': messageType,
        'senderID': senderID,
        'receiverID': receiverID,
        'seen': seen,
        'createdAt': createdAt.toUtc(),
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final ts = json['createdAt'];
    DateTime time;
    if (ts is DateTime) {
      time = ts;
    } else if (ts is Timestamp) {
      time = ts.toDate();
    } else if (ts is String) {
      time = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      time = DateTime.now();
    }
    return MessageModel(
      messageID: json['messageID'] as String? ?? '',
      message: json['message'] as String? ?? '',
      messageType: json['messageType'] as String? ?? 'text',
      senderID: json['senderID'] as String? ?? '',
      receiverID: json['receiverID'] as String? ?? '',
      seen: json['seen'] as bool? ?? false,
      createdAt: time,
    );
  }
}

