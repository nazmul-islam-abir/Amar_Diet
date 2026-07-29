import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/app_button.dart';
import '../services/api_service.dart';
import 'food_detail_screen.dart';

class FoodBrowseScreen extends StatefulWidget {
  const FoodBrowseScreen({super.key});

  @override
  State<FoodBrowseScreen> createState() => _FoodBrowseScreenState();
}

class _FoodBrowseScreenState extends State<FoodBrowseScreen> {
  String _category = 'rice';
  String _query = '';
  late Future<List<FoodItem>> _future;

  static const _categories = <_Category>[
    _Category('rice', 'Rice'),
    _Category('curry', 'Curry'),
    _Category('snacks', 'Snacks'),
    _Category('fish', 'Fish'),
    _Category('meat', 'Meat'),
    _Category('vegetable', 'Veg'),
    _Category('fruit', 'Fruits'),
    _Category('dairy', 'Dairy'),
    _Category('street_food', 'Street'),
    _Category('drink', 'Drinks'),
  ];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<FoodItem>> _load() {
    return ApiService.listFoods(category: _category);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  if (Navigator.canPop(context))
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: AppColors.textPrimary,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  const Text(
                    'Browse foods',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Discover Bangladeshi meals and snacks',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              GlassTextField(
                hint: 'Search biryani, fuchka, mango…',
                onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.search_rounded, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final c in _categories) ...[
                      GlassChip(
                        label: c.label,
                        selected: _category == c.key,
                        onTap: () {
                          setState(() => _category = c.key);
                          _refresh();
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: FutureBuilder<List<FoodItem>>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    }
                    if (snap.hasError) {
                      return _ErrorView(
                        message: snap.error.toString(),
                        onRetry: _refresh,
                      );
                    }
                    final all = snap.data ?? const <FoodItem>[];
                    final filtered = _query.isEmpty
                        ? all
                        : all
                            .where((f) =>
                                f.nameEn.toLowerCase().contains(_query) ||
                                (f.nameBn?.toLowerCase().contains(_query) ?? false))
                            .toList();
                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.no_food_rounded,
                                size: 48, color: AppColors.textSecondary),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              _query.isEmpty
                                  ? 'No foods in this category yet'
                                  : 'No matches for "$_query"',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (_, i) {
                        final f = filtered[i];
                        return _FoodGridCard(
                          item: f,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FoodDetailScreen(food: f),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.key, this.label);
  final String key;
  final String label;
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Retry', icon: Icons.refresh_rounded, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _FoodGridCard extends StatelessWidget {
  const _FoodGridCard({required this.item, required this.onTap});
  final FoodItem item;
  final VoidCallback onTap;

  IconData _icon() {
    final cat = item.category.toLowerCase();
    if (cat.contains('rice')) return Icons.rice_bowl_rounded;
    if (cat.contains('curry')) return Icons.soup_kitchen_rounded;
    if (cat.contains('fish')) return Icons.set_meal_rounded;
    if (cat.contains('meat')) return Icons.restaurant_rounded;
    if (cat.contains('fruit')) return Icons.eco_rounded;
    if (cat.contains('dairy')) return Icons.icecream_rounded;
    if (cat.contains('drink')) return Icons.local_drink_rounded;
    if (cat.contains('snack') || cat.contains('street')) {
      return Icons.bakery_dining_rounded;
    }
    return Icons.ramen_dining_rounded;
  }

  Color _tint() {
    final cat = item.category.toLowerCase();
    if (cat.contains('rice')) return AppColors.primary;
    if (cat.contains('curry')) return AppColors.secondary;
    if (cat.contains('fish')) return AppColors.info;
    if (cat.contains('meat')) return AppColors.primaryDark;
    if (cat.contains('fruit')) return AppColors.secondary;
    if (cat.contains('dairy')) return AppColors.accent;
    if (cat.contains('drink')) return AppColors.info;
    if (cat.contains('snack') || cat.contains('street')) return AppColors.accent;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final tint = _tint();
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tint.withValues(alpha: 0.85),
                    tint.withValues(alpha: 0.55),
                  ],
                ),
              ),
              child: Center(child: Icon(_icon(), color: Colors.white, size: 38)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.nameEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            item.nameBn ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '${item.kcal.round()} kcal / ${item.servingG.round()}g',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
