import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import 'src/features/transactions/domain/transaction_model.dart';
import 'src/features/transactions/data/wallet_repository.dart';
import 'src/core/services/notification_service.dart';
import 'src/features/bnpl/domain/bnpl_model.dart';
import 'src/features/bnpl/data/bnpl_repository.dart';
import 'src/features/rewards/domain/reward_model.dart';
import 'src/features/notifications/domain/notification_preferences.dart';
import 'src/features/rewards/data/rewards_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBdo-nXmSOdX2kqUAXL1U8DG3Cq3gbghkA',
          appId: '1:1001141776954:web:9782a3b1dccad96ea57b03',
          messagingSenderId: '1001141776954',
          projectId: 'cred-money-1d9a7',
          authDomain: 'cred-money-1d9a7.firebaseapp.com',
          storageBucket: 'cred-money-1d9a7.firebasestorage.app',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(TransactionCategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(BnplTransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(RewardTransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(NotificationPreferencesAdapter());
  }

  // Initialize Wallet Box
  final walletRepo = WalletRepository();
  await walletRepo.init();

  // Initialize BNPL Box
  final bnplRepo = BnplRepository();
  await bnplRepo.init();

  // Initialize Rewards Box
  final rewardsRepo = RewardsRepository();
  await rewardsRepo.init();

  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();

  // Open preferences box
  await Hive.openBox<NotificationPreferences>('preferences_box');

  runApp(
    ProviderScope(
      overrides: [
        // Override providers if necessary, or just rely on default
      ],
      child: const SmartFinanceApp(),
    ),
  );
}
