import 'package:expense/features/notifications/domain/models/notification_log.dart';
import 'package:isar/isar.dart';

part 'notification_log_isar.g.dart';

@collection
class NotificationLogIsar {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String patternId;
  late String type; // NotificationType as string
  late DateTime firedAt;
  late String response; // UserResponse as string
  double? addedAmount;

  NotificationLog toDomain() {
    return NotificationLog(
      id: id,
      patternId: patternId,
      type: NotificationType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => NotificationType.habitReminder,
      ),
      firedAt: firedAt,
      response: UserResponse.values.firstWhere(
        (e) => e.name == response,
        orElse: () => UserResponse.ignored,
      ),
      addedAmount: addedAmount,
    );
  }

  static NotificationLogIsar fromDomain(NotificationLog log) {
    return NotificationLogIsar()
      ..id = log.id
      ..patternId = log.patternId
      ..type = log.type.name
      ..firedAt = log.firedAt
      ..response = log.response.name
      ..addedAmount = log.addedAmount;
  }
}
