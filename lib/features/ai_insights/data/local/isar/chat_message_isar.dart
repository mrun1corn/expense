import 'package:expense/features/ai_insights/domain/models/chat_message.dart';
import 'package:isar/isar.dart';

part 'chat_message_isar.g.dart';

@collection
class ChatMessageIsar {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String text;
  late bool isUser;
  late DateTime timestamp;

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      text: text,
      isUser: isUser,
      timestamp: timestamp,
    );
  }

  static ChatMessageIsar fromDomain(ChatMessage message) {
    return ChatMessageIsar()
      ..id = message.id
      ..text = message.text
      ..isUser = message.isUser
      ..timestamp = message.timestamp;
  }
}