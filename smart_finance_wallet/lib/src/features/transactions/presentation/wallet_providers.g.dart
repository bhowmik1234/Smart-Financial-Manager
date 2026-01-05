// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletRepositoryHash() => r'2eb0b3ef4309e9076a96c5d4a4860856f53f552f';

/// See also [walletRepository].
@ProviderFor(walletRepository)
final walletRepositoryProvider = AutoDisposeProvider<WalletRepository>.internal(
  walletRepository,
  name: r'walletRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WalletRepositoryRef = AutoDisposeProviderRef<WalletRepository>;
String _$balanceHash() => r'5fa5de17cd47eef4dd3b05e97a7a67ded4ad7b1f';

/// See also [Balance].
@ProviderFor(Balance)
final balanceProvider = AutoDisposeNotifierProvider<Balance, double>.internal(
  Balance.new,
  name: r'balanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$balanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Balance = AutoDisposeNotifier<double>;
String _$transactionListHash() => r'3dfb0010a39b2abb971022b2e5f9df61df6740c5';

/// See also [TransactionList].
@ProviderFor(TransactionList)
final transactionListProvider =
    AutoDisposeNotifierProvider<TransactionList, List<Transaction>>.internal(
  TransactionList.new,
  name: r'transactionListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionList = AutoDisposeNotifier<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
