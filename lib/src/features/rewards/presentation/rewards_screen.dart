import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rewards_providers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_finance_wallet/src/core/presentation/widgets/glass_card.dart';

class RewardsMarketplaceScreen extends ConsumerStatefulWidget {
  const RewardsMarketplaceScreen({super.key});

  @override
  ConsumerState<RewardsMarketplaceScreen> createState() =>
      _RewardsMarketplaceScreenState();
}

class _RewardsMarketplaceScreenState
    extends ConsumerState<RewardsMarketplaceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coinBalanceProvider.notifier).refresh();
      ref.read(rewardsHistoryProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(coinBalanceProvider);
    final history = ref.watch(rewardsHistoryProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Rewards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0F0F),
              const Color(0xFF1A1A1A),
              Colors.amber.shade900.withOpacity(0.15),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber.withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  )
                                ],
                              ),
                            )
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true))
                                .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.2, 1.2),
                                    duration: 2000.ms),
                            const Icon(Icons.stars_rounded,
                                    size: 80, color: Colors.amber)
                                .animate(
                                    onPlay: (controller) => controller.repeat())
                                .shimmer(duration: 2000.ms, color: Colors.white)
                                .scaleXY(end: 1.1, duration: 1000.ms)
                                .then()
                                .scaleXY(end: 1.0, duration: 1000.ms),
                          ],
                        ),
                      ),
                      Text(
                        '$balance',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Outfit',
                            height: 1.0),
                      )
                          .animate()
                          .scale(duration: 400.ms, curve: Curves.easeOutBack),
                      Text(
                        'SMART COINS',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'REDEEM FOR',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                ),
              ),

              // Marketplace Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: const [
                    _RewardItem(
                      title: 'Gift Card',
                      subtitle: '\$10 Amazon',
                      cost: 500,
                      icon: Icons.card_giftcard_rounded,
                      color: Colors.blueAccent,
                    ),
                    _RewardItem(
                      title: 'Cashback',
                      subtitle: '\$5 Wallet',
                      cost: 1000,
                      icon: Icons.attach_money_rounded,
                      color: Colors.greenAccent,
                    ),
                    _RewardItem(
                      title: 'Premium',
                      subtitle: '1 Month Sub',
                      cost: 2000,
                      icon: Icons.diamond_rounded,
                      color: Colors.purpleAccent,
                    ),
                    _RewardItem(
                      title: 'Donation',
                      subtitle: 'Support Cause',
                      cost: 100,
                      icon: Icons.volunteer_activism_rounded,
                      color: Colors.pinkAccent,
                    ),
                  ],
                ),
              ),

              // History Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HISTORY',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              // History List
              history.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text('No history yet',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.3))),
                      )),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = history[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 4),
                            child: GlassCard(
                              opacity: 0.05,
                              borderRadius: 12,
                              child: ListTile(
                                dense: true,
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: (item.isCredit
                                              ? Colors.green
                                              : Colors.red)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    item.isCredit
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    color: item.isCredit
                                        ? const Color(0xFF00E676)
                                        : const Color(0xFFFF5252),
                                    size: 16,
                                  ),
                                ),
                                title: Text(
                                  item.description,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Text(
                                  '${item.isCredit ? '+' : '-'} ${item.amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: item.isCredit
                                        ? const Color(0xFF00E676)
                                        : const Color(0xFFFF5252),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: (30 * index).ms),
                          );
                        },
                        childCount: history.length,
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardItem extends ConsumerWidget {
  final String title;
  final String subtitle;
  final int cost;
  final IconData icon;
  final Color color;

  const _RewardItem({
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      opacity: 0.1,
      borderRadius: 20,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final success = await ref
              .read(rewardsControllerProvider.notifier)
              .redeemCoins(amount: cost, item: title);

          if (context.mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Redeemed $title!',
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFF00E676),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Insufficient coins'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.3))),
                child: Icon(icon, size: 32, color: color)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                        duration: 2000.ms),
              ),
              const Spacer(),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16)),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 12)),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.withOpacity(0.3))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('$cost',
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale();
  }
}
