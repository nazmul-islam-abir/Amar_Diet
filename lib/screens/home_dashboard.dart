import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';
import '../widgets/app_button.dart';
import '../services/api_service.dart';
import 'food_recommend_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late Future<_HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_HomeData> _load() async {
    final today = DateTime.now();
    final results = await Future.wait([
      ApiService.getProgress(),
      ApiService.ensureProfile(),
      ApiService.listMeals(date: today),
    ]);
    return _HomeData(
      progress: results[0] as ProgressReport,
      profile: results[1] as UserProfile,
      meals: results[2] as List<MealEntry>,
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  String _today() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _addWater() async {
    try {
      await ApiService.addWater(250);
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _openFoodRec() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FoodRecommendScreen()),
    );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.primary,
          child: FutureBuilder<_HomeData>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 80),
                    Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ],
                );
              }
              if (snap.hasError) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  children: [
                    const SizedBox(height: 80),
                    _ErrorBox(
                      message: snap.error.toString(),
                      onRetry: _refresh,
                    ),
                  ],
                );
              }
              final data = snap.data!;
              return _Body(
                data: data,
                greeting: _greeting(),
                onAddWater: _addWater,
                onFoodRec: _openFoodRec,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeData {
  _HomeData({required this.progress, required this.profile, required this.meals});
  final ProgressReport progress;
  final UserProfile profile;
  final List<MealEntry> meals;
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textSecondary),
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
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.data,
    required this.greeting,
    required this.onAddWater,
    required this.onFoodRec,
  });
  final _HomeData data;
  final String greeting;
  final VoidCallback onAddWater;
  final VoidCallback onFoodRec;

  String _name() {
    final n = data.profile.name?.trim();
    if (n == null || n.isEmpty) return 'Friend';
    return n.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final p = data.progress;
    final kcalIn = p.kcalIn.round();
    final kcalTarget = p.kcalTarget.round();
    final kcalRemaining = (kcalTarget - kcalIn).clamp(0, kcalTarget);
    final carbsG = p.carbsIn.round();
    final proteinG = p.proteinIn.round();
    final fatG = p.fatIn.round();
    final waterL = p.waterMl / 1000;
    final waterTargetL = p.waterTarget / 1000;
    final macros = p.macros;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Greeting(greeting: greeting, name: _name()),
          const SizedBox(height: AppSpacing.xl),
          _CalorieRingCard(
            consumed: kcalIn,
            goal: kcalTarget,
            remaining: kcalRemaining,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MacroCard(
                  label: 'Carbs',
                  value: carbsG,
                  goal: (macros['carbs_g'] as num?)?.toInt() ?? 260,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MacroCard(
                  label: 'Protein',
                  value: proteinG,
                  goal: (macros['protein_g'] as num?)?.toInt() ?? 110,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MacroCard(
                  label: 'Fat',
                  value: fatG,
                  goal: (macros['fat_g'] as num?)?.toInt() ?? 65,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _WaterWidget(
            consumedL: waterL,
            targetL: waterTargetL,
            onAdd: onAddWater,
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: "Today's meals",
            action: 'See all',
            onAction: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          if (data.meals.isEmpty)
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'No meals logged yet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Tap the + button to log your first meal.",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            ...data.meals.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _MealItem(
                    type: _mealTypeLabel(m.mealType),
                    time: _fmtTime(m.createdAt),
                    title: m.foodName.isEmpty ? 'Meal' : m.foodName,
                    kcal: m.kcalTotal.round(),
                    icon: _iconForMeal(m.mealType),
                    tint: _tintForMeal(m.mealType),
                  ),
                )),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: 'Recommended for you',
            action: 'More',
            onAction: onFoodRec,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 168,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _RecommendCard(
                  title: 'Khichuri with Egg',
                  tint: AppColors.primary,
                  icon: Icons.rice_bowl_rounded,
                ),
                SizedBox(width: AppSpacing.md),
                _RecommendCard(
                  title: 'Masoor Dal + Rice',
                  tint: AppColors.secondary,
                  icon: Icons.soup_kitchen_rounded,
                ),
                SizedBox(width: AppSpacing.md),
                _RecommendCard(
                  title: 'Beguni & Peyaji',
                  tint: AppColors.accent,
                  icon: Icons.bakery_dining_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final h24 = dt.hour;
    final h12 = h24 == 0 ? 12 : (h24 > 12 ? h24 - 12 : h24);
    final ampm = h24 < 12 ? 'AM' : 'PM';
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$h12:$mm $ampm';
  }

  String _mealTypeLabel(String type) {
    switch (type) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
        return 'Snack';
      default:
        return type.isEmpty ? 'Meal' : type;
    }
  }

  IconData _iconForMeal(String type) {
    switch (type) {
      case 'breakfast':
        return Icons.wb_sunny_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      case 'snack':
        return Icons.icecream_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  Color _tintForMeal(String type) {
    switch (type) {
      case 'breakfast':
        return AppColors.accent;
      case 'lunch':
        return AppColors.primary;
      case 'dinner':
        return AppColors.primaryDark;
      case 'snack':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.greeting, required this.name});
  final String greeting;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hello, $name 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.glassWhite, AppColors.glassWhiteSoft],
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _CalorieRingCard extends StatelessWidget {
  const _CalorieRingCard({
    required this.consumed,
    required this.goal,
    required this.remaining,
  });
  final int consumed;
  final int goal;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final safeGoal = goal <= 0 ? 1 : goal;
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Row(
        children: [
          _CalorieRing(consumed: consumed, goal: safeGoal),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calories today',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: consumed.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' / $goal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '$remaining kcal left',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieRing extends StatelessWidget {
  const _CalorieRing({required this.consumed, required this.goal});
  final int consumed;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / goal).clamp(0.0, 1.0);
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                'of goal',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  final String label;
  final int value;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final safeGoal = goal <= 0 ? 1 : goal;
    final progress = (value / safeGoal).clamp(0.0, 1.0);
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '$label • ${goal}g',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterWidget extends StatelessWidget {
  const _WaterWidget({
    required this.consumedL,
    required this.targetL,
    required this.onAdd,
  });
  final double consumedL;
  final double targetL;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.info.withValues(alpha: 0.7),
                  AppColors.info.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Water intake',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${consumedL.toStringAsFixed(1)} L / ${targetL.toStringAsFixed(1)} L',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.info, Color(0xFF60A5FA)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Text(
                '+ 250ml',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealItem extends StatelessWidget {
  const _MealItem({
    required this.type,
    required this.time,
    required this.title,
    required this.kcal,
    required this.icon,
    required this.tint,
  });

  final String type;
  final String time;
  final String title;
  final int kcal;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: tint, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '$kcal kcal',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendCard extends StatelessWidget {
  const _RecommendCard({
    required this.title,
    required this.tint,
    required this.icon,
  });

  final String title;
  final Color tint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 200,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tint.withValues(alpha: 0.85),
                  tint.withValues(alpha: 0.55),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Text(
              'View',
              style: TextStyle(
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
