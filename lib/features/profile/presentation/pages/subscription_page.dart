import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sin_flix/core/theme/app_colors.dart';

class SubscriptionPage extends StatelessWidget {
  static const routePath = '/subscription';

  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            /* header blur */
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryRed.withOpacity(.7),
                    AppColors.primaryBlack
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text('Sınırlı Teklif',
                    style: t.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white)),
              ),
            ),
            const SizedBox(height: 12),
            Text('Jeton paketini seçerek bonus \n'
                'kazanın ve yeni bölümlerin kilidini açın!',
                textAlign: TextAlign.center,
                style: t.bodyMedium),
            const SizedBox(height: 20),

            /* bonuses row */
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground.withOpacity(.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _Bonus(icon: Icons.star, label: 'Premium\nHesap'),
                  _Bonus(icon: Icons.favorite, label: 'Daha\nFazla Eşleşme'),
                  _Bonus(icon: Icons.north, label: 'Öne\nÇıkarma'),
                  _Bonus(icon: Icons.thumb_up, label: 'Daha\nFazla Beğeni'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Kilidi açmak için bir jeton paketi seçin',
                style: t.bodySmall?.copyWith(color: AppColors.lightGrey)),

            const SizedBox(height: 24),

            /* packages */
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _PackCard(
                    topLabel: '+10%',
                    color: Colors.red,
                    price: '₺99,99',
                    coins: '330',
                  ),
                  SizedBox(height: 16),
                  _PackCard(
                    topLabel: '+70%',
                    color: Colors.blue,
                    price: '₺799,99',
                    coins: '3.375',
                    featured: true,
                  ),
                  SizedBox(height: 16),
                  _PackCard(
                    topLabel: '+35%',
                    color: Colors.red,
                    price: '₺399,99',
                    coins: '1.350',
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.pop(),
                child: const Text('Tüm Jetonları Gör'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- helpers ---------------- */
class _Bonus extends StatelessWidget {
  const _Bonus({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryRed),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.white)),
      ],
    );
  }
}

class _PackCard extends StatelessWidget {
  const _PackCard({
    required this.topLabel,
    required this.color,
    required this.price,
    required this.coins,
    this.featured = false,
  });

  final String topLabel;
  final Color color;
  final String price;
  final String coins;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(.9),
            color.withOpacity(.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 8,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack.withOpacity(.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(topLabel,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Text(coins,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Jeton'),
                  const SizedBox(height: 12),
                  Text(price,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Başına haftalık',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.lightGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
