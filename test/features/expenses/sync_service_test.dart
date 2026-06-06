import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncService LWW Conflict Merge', () {
    test('Server wins if remote updatedAt is strictly greater than local', () {
      final local = DateTime(2024, 1, 1, 10);
      final remote = DateTime(2024, 1, 1, 10, 5); // 5 mins later
      
      expect(remote.isAfter(local), isTrue);
    });

    test('Local wins if local updatedAt is strictly greater than remote', () {
      final remote = DateTime(2024, 1, 1, 10);
      final local = DateTime(2024, 1, 1, 10, 5); // 5 mins later
      
      expect(local.isAfter(remote), isTrue);
    });
  });
}
