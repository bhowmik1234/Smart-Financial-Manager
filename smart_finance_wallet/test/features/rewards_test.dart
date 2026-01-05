import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_wallet/src/features/rewards/presentation/rewards_providers.dart';

void main() {
  group('Rewards Tests', () {
    test('CoinBalance initially 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(coinBalanceProvider), 0);
    });

    // Since our providers rely on Hive boxes which are difficult to mock without
    // substantial setup or a real repository abstraction that we can mock,
    // we've limited unit tests here.
    // Ideally we would mock the RewardsRepository.
  });
}
