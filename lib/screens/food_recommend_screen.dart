import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import 'food_detail_screen.dart';
import '../services/api_service.dart';

class FoodRecommendScreen extends StatefulWidget {
  const FoodRecommendScreen({super.key});

  @override
  State<FoodRecommendScreen> createState() => _FoodRecommendScreenState();
}

class _FoodRecommendScreenState extends State<FoodRecommendScreen> {
  final _controller = PageController(viewportFraction: 0.88);
  int _index = 0;

  static const _items = [
    _FoodCard(
      title: 'Khichuri with Egg',
      subtitle: 'খিচুড়ি ও ডিম',
      desc: 'A comforting one-pot mix of rice, lentils, spices and a soft-boiled egg.',
      kcal: 480,
      protein: 18,
      carbs: 72,
      fat: 14,
      tint: AppColors.primary,
      icon: Icons.rice_bowl_rounded,
      ingredients: ['Rice', 'Lentils', 'Egg', 'Onion', 'Spices'],
    ),
    _FoodCard(
      title: 'Masoor Dal & Rice',
      subtitle: 'মসুর ডাল ও ভাত',
      desc: 'Steamed rice with red lentil dal tempered with cumin and garlic.',
      kcal: 520,
      protein: 16,
      carbs: 88,
      fat: 9,
      tint: AppColors.secondary,
      icon: Icons.soup_kitchen_rounded,
      ingredients: ['Rice', 'Red lentils', 'Cumin', 'Garlic'],
    ),
    _FoodCard(
      title: 'Beguni & Peyaji',
      subtitle: 'বেগুনি ও পেঁয়াজি',
      desc: 'Crispy fried eggplant slices and onion fritters — a tea-time classic.',
      kcal: 320,
      protein: 6,
      carbs: 36,
      fat: 18,
      tint: AppColors.accent,
      icon: Icons.bakery_dining_rounded,
      ingredients: ['Eggplant', 'Onion', 'Gram flour', 'Chili'],
    ),
    _FoodCard(
      title: 'Hilsa Fish Curry',
      subtitle: 'ইলিশ মাছের ঝোল',
      desc: 'Bengali favourite Hilsa simmered in mustard and green chili.',
      kcal: 460,
      protein: 28,
      carbs: 12,
      fat: 28,
      tint: AppColors.primaryDark,
      icon: Icons.set_meal_rounded,
      ingredients: ['Hilsa', 'Mustard', 'Green chili', 'Turmeric'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppColors.textPrimary,
                    ),
                    const Spacer(),
                    const Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Swipe to explore',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Curated for your goals and dietary preferences.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemCount: _items.length,
                  itemBuilder: (_, i) {
                    final item = _items[i];
                    final isActive = i == _index;
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 320),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: isActive ? 0 : 24,
                      ),
                      child: _SwipeCard(
                        item: item,
                        onTap: () {
                          final f = FoodItem(
                            id: 'rec_$i',
                            nameEn: item.title,
                            nameBn: item.subtitle,
                            category: 'Recommended',
                            servingG: 100,
                            kcalPerServing: item.kcal.toDouble(),
                            proteinG: item.protein.toDouble(),
                            carbsG: item.carbs.toDouble(),
                            fatG: item.fat.toDouble(),
                            fiberG: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(food: f),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < _items.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: i == _index ? 22 : 6,
                      decoration: BoxDecoration(
                        color: i == _index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
    );
  }
}

class _FoodCard {
  const _FoodCard({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.tint,
    required this.icon,
    required this.ingredients,
  });
  final String title;
  final String subtitle;
  final String desc;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;
  final Color tint;
  final IconData icon;
  final List<String> ingredients;
}

class _SwipeCard extends StatelessWidget {
  const _SwipeCard({required this.item, required this.onTap});
  final _FoodCard item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.tint.withValues(alpha: 0.85),
                  item.tint.withValues(alpha: 0.55),
                ],
              ),
            ),
            child: Center(
              child: Icon(item.icon, color: Colors.white, size: 80),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${item.kcal} kcal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            item.desc,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _MiniStat(label: 'Protein', value: '${item.protein}g'),
              const SizedBox(width: 8),
              _MiniStat(label: 'Carbs', value: '${item.carbs}g'),
              const SizedBox(width: 8),
              _MiniStat(label: 'Fat', value: '${item.fat}g'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.add_rounded, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$label $value',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
