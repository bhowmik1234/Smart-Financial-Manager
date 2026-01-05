import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rewards_providers.dart';

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
      appBar: AppBar(
        title: const Text('Rewards Marketplace'),
      ),
      body: CustomScrollView(
        slivers: [
import 'package:flutter_animate/flutter_animate.dart';

// ... (existing imports)

          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(32),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  const Icon(Icons.stars, size: 64, color: Colors.amber)
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2000.ms, color: Colors.amberAccent)
                      .scaleXY(end: 1.1, duration: 1000.ms)
                      .then()
                      .scaleXY(end: 1.0, duration: 1000.ms),
                  const SizedBox(height: 16),
                  Text(
                    '$balance',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  Text(
                    'Smart Coins',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          
          // Marketplace Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _RewardItem(
                  title: 'Ammount Gift Card',
                  cost: 500,
                  icon: Icons.card_giftcard,
                ),
                _RewardItem(
                  title: 'Cashback \$5',
                  cost: 1000,
                  icon: Icons.attach_money,
                ),
                _RewardItem(
                  title: 'Premium Subscription',
                  cost: 2000,
                  icon: Icons.diamond,
                ),
                _RewardItem(
                  title: 'Charity Donation',
                  cost: 100,
                  icon: Icons.volunteer_activism,
                ),
              ],
            ),
          ),

          // History Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'History',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // History List
          history.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No history yet'),
                  )),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = history[index];
                      return ListTile(
                        leading: Icon(
                          item.isCredit
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: item.isCredit ? Colors.green : Colors.red,
                        ),
                        title: Text(item.description),
                        trailing: Text(
                          '${item.isCredit ? '+' : '-'} ${item.amount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.isCredit ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                    childCount: history.length,
                  ),
                ),
        ],
      ),
    );
  }
}

class _RewardItem extends ConsumerWidget {
  final String title;
  final int cost;
  final IconData icon;

  const _RewardItem({
    required this.title,
    required this.cost,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          // ... (existing logic)
          // Simplified for brevity in replace
           final success = await ref
              .read(rewardsControllerProvider.notifier)
              .redeemCoins(amount: cost, item: title);

          if (context.mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Redeemed $title!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Insufficient coins')),
              );
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor)
                .animate()
                .scale(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('$cost'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }
}
