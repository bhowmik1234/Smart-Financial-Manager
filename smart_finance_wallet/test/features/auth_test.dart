import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_wallet/src/features/authentication/presentation/auth_providers.dart';

void main() {
  group('Auth Tests', () {
    test('Auth state is initially loading or unauthenticated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authStateChangesProvider);

      expect(authState, isA<AsyncLoading>());
    });
  });
}
