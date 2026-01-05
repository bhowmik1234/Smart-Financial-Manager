// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bnpl_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bnplRepositoryHash() => r'eb744e88fd1fa2b13983f577e36932c9a05cde60';

/// See also [bnplRepository].
@ProviderFor(bnplRepository)
final bnplRepositoryProvider = AutoDisposeProvider<BnplRepository>.internal(
  bnplRepository,
  name: r'bnplRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bnplRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BnplRepositoryRef = AutoDisposeProviderRef<BnplRepository>;
String _$bnplTransactionsHash() => r'0787b27fec770c15a4af435cac56556488c2be4c';

/// See also [BnplTransactions].
@ProviderFor(BnplTransactions)
final bnplTransactionsProvider = AutoDisposeNotifierProvider<BnplTransactions,
    List<BnplTransaction>>.internal(
  BnplTransactions.new,
  name: r'bnplTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bnplTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BnplTransactions = AutoDisposeNotifier<List<BnplTransaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
