// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rewardsRepositoryHash() => r'75146c90fb61cc600d3ab8fde9969dc3c9e7ded9';

/// See also [rewardsRepository].
@ProviderFor(rewardsRepository)
final rewardsRepositoryProvider =
    AutoDisposeProvider<RewardsRepository>.internal(
  rewardsRepository,
  name: r'rewardsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rewardsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RewardsRepositoryRef = AutoDisposeProviderRef<RewardsRepository>;
String _$coinBalanceHash() => r'02d8efd5d2fc9f2c2479a209f46fe2db83ef06e4';

/// See also [CoinBalance].
@ProviderFor(CoinBalance)
final coinBalanceProvider =
    AutoDisposeNotifierProvider<CoinBalance, int>.internal(
  CoinBalance.new,
  name: r'coinBalanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$coinBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CoinBalance = AutoDisposeNotifier<int>;
String _$rewardsHistoryHash() => r'c5d4c0dee46042fd065166309ed81d95330ce075';

/// See also [RewardsHistory].
@ProviderFor(RewardsHistory)
final rewardsHistoryProvider = AutoDisposeNotifierProvider<RewardsHistory,
    List<RewardTransaction>>.internal(
  RewardsHistory.new,
  name: r'rewardsHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rewardsHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RewardsHistory = AutoDisposeNotifier<List<RewardTransaction>>;
String _$rewardsControllerHash() => r'0e3c13ea3b91f62624b4339a497d6a0a6ba21d04';

/// See also [RewardsController].
@ProviderFor(RewardsController)
final rewardsControllerProvider =
    AutoDisposeNotifierProvider<RewardsController, void>.internal(
  RewardsController.new,
  name: r'rewardsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rewardsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RewardsController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
