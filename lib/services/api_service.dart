// =====================================================================
// Amar Diet — offline data layer
// =====================================================================
//
// All data lives in-memory. No HTTP, no Neon, no CPanel. The app still
// talks to BDApps for OTP / subscription, but every screen (profile,
// meals, water, plan, progress) reads from this in-memory store.
//
// The on-screen experience is identical to the original UI kit:
//  - 20 Bangladesh food items hard-coded
//  - Profile auto-created from the verified phone on first read
//  - All CRUD is instant and local
// =====================================================================

import 'auth_service.dart';

// ---------------------------------------------------------------------
//  Models
// ---------------------------------------------------------------------

class UserProfile {
  const UserProfile({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.goal,
    this.targetWeightKg,
    this.dietPref,
    this.bmr,
    this.tdee,
    this.dailyCalorieTarget,
    this.isPro = false,
  });

  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String? gender;
  final DateTime? dateOfBirth;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final String? goal;
  final double? targetWeightKg;
  final String? dietPref;
  final double? bmr;
  final double? tdee;
  final double? dailyCalorieTarget;
  final bool isPro;

  String? get initials {
    final n = name?.trim();
    if (n == null || n.isEmpty) return null;
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  double? get bmi {
    if (heightCm == null || weightKg == null || heightCm == 0) return null;
    final m = heightCm! / 100.0;
    return weightKg! / (m * m);
  }

  String bmiLabel() {
    final b = bmi;
    if (b == null) return '—';
    if (b < 18.5) return 'under';
    if (b < 25) return 'normal';
    if (b < 30) return 'over';
    return 'obese';
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goal,
    double? targetWeightKg,
    String? dietPref,
    double? bmr,
    double? tdee,
    double? dailyCalorieTarget,
  }) {
    return UserProfile(
      id: id,
      phone: phone,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      dietPref: dietPref ?? this.dietPref,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      dailyCalorieTarget:
          dailyCalorieTarget ?? this.dailyCalorieTarget,
      isPro: isPro,
    );
  }

  Map<String, dynamic> toUpdateFields() => {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null)
          'date_of_birth':
              '${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}',
        if (heightCm != null) 'height_cm': heightCm,
        if (weightKg != null) 'weight_kg': weightKg,
        if (activityLevel != null) 'activity_level': activityLevel,
        if (goal != null) 'goal': goal,
        if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
        if (dietPref != null) 'diet_pref': dietPref,
      };
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.nameEn,
    required this.category,
    required this.servingG,
    required this.kcalPerServing,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    this.nameBn,
  });

  final String id;
  final String nameEn;
  final String? nameBn;
  final String category;
  final double servingG;
  final double kcalPerServing;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;

  String get displayName =>
      (nameBn != null && nameBn!.isNotEmpty) ? nameBn! : nameEn;
  double get kcal => kcalPerServing;
}

class MealEntry {
  const MealEntry({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.mealType,
    required this.servings,
    required this.eatenOn,
    required this.kcalTotal,
    required this.proteinTotal,
    required this.carbsTotal,
    required this.fatTotal,
    required this.createdAt,
  });

  final String id;
  final String foodId;
  final String foodName;
  final String mealType;
  final double servings;
  final DateTime eatenOn;
  final double kcalTotal;
  final double proteinTotal;
  final double carbsTotal;
  final double fatTotal;
  final DateTime createdAt;
}

class WaterLog {
  const WaterLog({
    required this.date,
    required this.totalMl,
    required this.targetMl,
    required this.entries,
  });
  factory WaterLog.empty() => WaterLog(
        date: DateTime.now(),
        totalMl: 0,
        targetMl: 2500,
        entries: const [],
      );

  final DateTime date;
  final int totalMl;
  final int targetMl;
  final List<WaterEntry> entries;
}

class WaterEntry {
  const WaterEntry({
    required this.id,
    required this.amountMl,
    required this.loggedOn,
    required this.loggedAt,
  });
  final String id;
  final int amountMl;
  final DateTime loggedOn;
  final DateTime? loggedAt;
}

class DailyPlan {
  const DailyPlan({
    required this.planDate,
    required this.kcalTarget,
    required this.waterMl,
    this.notes,
  });
  factory DailyPlan.empty() => DailyPlan(
        planDate: DateTime.now(),
        kcalTarget: 2000,
        waterMl: 2500,
      );

  final DateTime planDate;
  final double kcalTarget;
  final int waterMl;
  final String? notes;
}

class ProgressReport {
  const ProgressReport({
    required this.today,
    required this.target,
    required this.week,
    required this.streak,
    required this.weight,
    required this.macros,
  });

  factory ProgressReport.empty() => ProgressReport(
        today: const {
          'kcal_in': 0,
          'protein_in': 0,
          'carbs_in': 0,
          'fat_in': 0,
          'water_ml': 0,
          'kcal_out': 0,
        },
        target: const {'kcal': 2000, 'water_ml': 2500},
        week: const [],
        streak: 0,
        weight: const {'start': null, 'current': null, 'delta': null},
        macros: const {'protein_g': 110, 'carbs_g': 260, 'fat_g': 60},
      );

  final Map<String, dynamic> today;
  final Map<String, dynamic> target;
  final List<Map<String, dynamic>> week;
  final int streak;
  final Map<String, dynamic> weight;
  final Map<String, dynamic> macros;

  double get kcalIn => (today['kcal_in'] as num?)?.toDouble() ?? 0;
  double get proteinIn => (today['protein_in'] as num?)?.toDouble() ?? 0;
  double get carbsIn => (today['carbs_in'] as num?)?.toDouble() ?? 0;
  double get fatIn => (today['fat_in'] as num?)?.toDouble() ?? 0;
  int get waterMl => (today['water_ml'] as num?)?.toInt() ?? 0;
  double get kcalOut => (today['kcal_out'] as num?)?.toDouble() ?? 0;

  double get kcalTarget => (target['kcal'] as num?)?.toDouble() ?? 2000;
  int get waterTarget => (target['water_ml'] as num?)?.toInt() ?? 2500;

  double get proteinGoal =>
      (macros['protein_g'] as num?)?.toDouble() ?? 110;
  double get carbsGoal => (macros['carbs_g'] as num?)?.toDouble() ?? 260;
  double get fatGoal => (macros['fat_g'] as num?)?.toDouble() ?? 60;
}

// ---------------------------------------------------------------------
//  Bangladesh food library — 20 items
// ---------------------------------------------------------------------

const List<FoodItem> _kFoodLibrary = [
  FoodItem(
    id: 'rice_plain',
    nameEn: 'Plain Rice',
    nameBn: 'ভাত',
    category: 'rice',
    servingG: 150,
    kcalPerServing: 205,
    proteinG: 4.3,
    carbsG: 45,
    fatG: 0.5,
    fiberG: 0.6,
  ),
  FoodItem(
    id: 'roti',
    nameEn: 'Roti',
    nameBn: 'রুটি',
    category: 'rice',
    servingG: 40,
    kcalPerServing: 120,
    proteinG: 3.7,
    carbsG: 24,
    fatG: 0.8,
    fiberG: 2.0,
  ),
  FoodItem(
    id: 'chicken_curry',
    nameEn: 'Chicken Curry',
    nameBn: 'মুরগির ঝোল',
    category: 'curry',
    servingG: 150,
    kcalPerServing: 270,
    proteinG: 25,
    carbsG: 6,
    fatG: 16,
    fiberG: 1.0,
  ),
  FoodItem(
    id: 'hilsa_fish',
    nameEn: 'Hilsa Fish Curry',
    nameBn: 'ইলিশ মাছের ঝোল',
    category: 'fish',
    servingG: 150,
    kcalPerServing: 290,
    proteinG: 27,
    carbsG: 4,
    fatG: 19,
    fiberG: 0.5,
  ),
  FoodItem(
    id: 'rui_fish',
    nameEn: 'Rui Fish Curry',
    nameBn: 'রুই মাছের ঝোল',
    category: 'fish',
    servingG: 150,
    kcalPerServing: 230,
    proteinG: 26,
    carbsG: 3,
    fatG: 12,
    fiberG: 0.4,
  ),
  FoodItem(
    id: 'lentil_dal',
    nameEn: 'Masoor Dal',
    nameBn: 'মসুর ডাল',
    category: 'curry',
    servingG: 150,
    kcalPerServing: 180,
    proteinG: 12,
    carbsG: 25,
    fatG: 4,
    fiberG: 6,
  ),
  FoodItem(
    id: 'mixed_veg',
    nameEn: 'Mixed Vegetables',
    nameBn: 'মিক্স সবজি',
    category: 'vegetable',
    servingG: 150,
    kcalPerServing: 130,
    proteinG: 4,
    carbsG: 15,
    fatG: 6,
    fiberG: 5,
  ),
  FoodItem(
    id: 'banana',
    nameEn: 'Banana',
    nameBn: 'কলা',
    category: 'fruit',
    servingG: 120,
    kcalPerServing: 105,
    proteinG: 1.3,
    carbsG: 27,
    fatG: 0.4,
    fiberG: 3.0,
  ),
  FoodItem(
    id: 'boiled_egg',
    nameEn: 'Boiled Egg',
    nameBn: 'সেদ্ধ ডিম',
    category: 'meat',
    servingG: 50,
    kcalPerServing: 78,
    proteinG: 6,
    carbsG: 0.6,
    fatG: 5,
    fiberG: 0,
  ),
  FoodItem(
    id: 'milk',
    nameEn: 'Milk',
    nameBn: 'দুধ',
    category: 'dairy',
    servingG: 200,
    kcalPerServing: 120,
    proteinG: 6,
    carbsG: 10,
    fatG: 6,
    fiberG: 0,
  ),
  FoodItem(
    id: 'tea_sugar',
    nameEn: 'Tea with Sugar',
    nameBn: 'চা চিনি',
    category: 'drink',
    servingG: 200,
    kcalPerServing: 70,
    proteinG: 0.4,
    carbsG: 17,
    fatG: 0.5,
    fiberG: 0,
  ),
  FoodItem(
    id: 'biryani',
    nameEn: 'Chicken Biryani',
    nameBn: 'বিরিয়ানি',
    category: 'rice',
    servingG: 250,
    kcalPerServing: 490,
    proteinG: 22,
    carbsG: 65,
    fatG: 17,
    fiberG: 2.5,
  ),
  FoodItem(
    id: 'khichuri',
    nameEn: 'Khichuri',
    nameBn: 'খিচুড়ি',
    category: 'rice',
    servingG: 250,
    kcalPerServing: 420,
    proteinG: 14,
    carbsG: 68,
    fatG: 10,
    fiberG: 4,
  ),
  FoodItem(
    id: 'curd',
    nameEn: 'Curd (Doi)',
    nameBn: 'দই',
    category: 'dairy',
    servingG: 150,
    kcalPerServing: 110,
    proteinG: 5,
    carbsG: 9,
    fatG: 6,
    fiberG: 0,
  ),
  FoodItem(
    id: 'cucumber',
    nameEn: 'Cucumber',
    nameBn: 'শসা',
    category: 'vegetable',
    servingG: 100,
    kcalPerServing: 16,
    proteinG: 0.7,
    carbsG: 3.6,
    fatG: 0.1,
    fiberG: 0.5,
  ),
  FoodItem(
    id: 'apple',
    nameEn: 'Apple',
    nameBn: 'আপেল',
    category: 'fruit',
    servingG: 150,
    kcalPerServing: 78,
    proteinG: 0.4,
    carbsG: 21,
    fatG: 0.3,
    fiberG: 3.5,
  ),
  FoodItem(
    id: 'beef_curry',
    nameEn: 'Beef Curry',
    nameBn: 'গরুর মাংসের ঝোল',
    category: 'meat',
    servingG: 150,
    kcalPerServing: 310,
    proteinG: 26,
    carbsG: 5,
    fatG: 21,
    fiberG: 0.5,
  ),
  FoodItem(
    id: 'mango',
    nameEn: 'Mango',
    nameBn: 'আম',
    category: 'fruit',
    servingG: 150,
    kcalPerServing: 100,
    proteinG: 1.4,
    carbsG: 25,
    fatG: 0.6,
    fiberG: 2.5,
  ),
  FoodItem(
    id: 'paratha',
    nameEn: 'Paratha',
    nameBn: 'পরোটা',
    category: 'street_food',
    servingG: 80,
    kcalPerServing: 290,
    proteinG: 6,
    carbsG: 36,
    fatG: 13,
    fiberG: 2,
  ),
  FoodItem(
    id: 'samosa',
    nameEn: 'Samosa',
    nameBn: 'সমোসা',
    category: 'snacks',
    servingG: 60,
    kcalPerServing: 180,
    proteinG: 4,
    carbsG: 22,
    fatG: 9,
    fiberG: 1.5,
  ),
];

// ---------------------------------------------------------------------
//  ApiService — in-memory state per verified phone
// ---------------------------------------------------------------------

class ApiService {
  ApiService._();

  // ----- Store: keyed by phone -----
  static final Map<String, UserProfile> _profiles = {};
  static final Map<String, List<MealEntry>> _meals = {};
  static final Map<String, List<WaterEntry>> _water = {};
  static final Map<String, DailyPlan> _plans = {};
  static final Map<String, List<Map<String, dynamic>>> _weight = {};
  static int _seq = 0;

  // ----- Helpers -----

  static String _phone() {
    final p = AuthService.instance.phone;
    return p ?? 'guest';
  }

  static String _genId(String prefix) {
    _seq++;
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}_$_seq';
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static FoodItem? _findFood(String id) {
    for (final f in _kFoodLibrary) {
      if (f.id == id) return f;
    }
    return null;
  }

  // ----- Profile -----

  static Future<UserProfile> ensureProfile() async {
    final phone = _phone();
    final existing = _profiles[phone];
    final p = existing ??
        UserProfile(
          id: 'local_$phone',
          phone: phone,
          isPro: AuthService.instance.isSubscribed,
          dailyCalorieTarget: 2000,
        );
    // Always refresh subscription state from AuthService.
    final synced = _rebuildFreshIsPro(p, AuthService.instance.isSubscribed);
    _profiles[phone] = synced;
    return synced;
  }

  static UserProfile _rebuildFreshIsPro(UserProfile p, bool isPro) {
    return UserProfile(
      id: p.id,
      phone: p.phone,
      name: p.name,
      email: p.email,
      gender: p.gender,
      dateOfBirth: p.dateOfBirth,
      heightCm: p.heightCm,
      weightKg: p.weightKg,
      activityLevel: p.activityLevel,
      goal: p.goal,
      targetWeightKg: p.targetWeightKg,
      dietPref: p.dietPref,
      bmr: p.bmr,
      tdee: p.tdee,
      dailyCalorieTarget: p.dailyCalorieTarget,
      isPro: isPro,
    );
  }

  static Future<UserProfile> updateProfile(
      Map<String, dynamic> fields) async {
    final phone = _phone();
    final current = await ensureProfile();
    UserProfile updated = current;
    if (fields.containsKey('name')) updated = _rebuild(updated, name: fields['name']?.toString());
    if (fields.containsKey('email')) updated = _rebuild(updated, email: fields['email']?.toString());
    if (fields.containsKey('gender')) updated = _rebuild(updated, gender: fields['gender']?.toString());
    if (fields.containsKey('date_of_birth')) {
      final v = fields['date_of_birth']?.toString();
      updated = _rebuild(updated, dateOfBirth: v == null ? null : DateTime.tryParse(v));
    }
    if (fields.containsKey('height_cm')) updated = _rebuild(updated, heightCm: (fields['height_cm'] as num?)?.toDouble());
    if (fields.containsKey('weight_kg')) updated = _rebuild(updated, weightKg: (fields['weight_kg'] as num?)?.toDouble());
    if (fields.containsKey('activity_level')) updated = _rebuild(updated, activityLevel: fields['activity_level']?.toString());
    if (fields.containsKey('goal')) updated = _rebuild(updated, goal: fields['goal']?.toString());
    if (fields.containsKey('target_weight_kg')) updated = _rebuild(updated, targetWeightKg: (fields['target_weight_kg'] as num?)?.toDouble());
    if (fields.containsKey('diet_pref')) updated = _rebuild(updated, dietPref: fields['diet_pref']?.toString());

    // Recompute BMR, TDEE, daily calorie target.
    final bmr = _bmrFromProfile(updated);
    final tdee = _tdeeFromProfile(updated, bmr);
    final kcalTarget = _dailyCalorieTarget(updated, tdee);
    updated = _rebuild(updated, bmr: bmr, tdee: tdee, dailyCalorieTarget: kcalTarget);

    _profiles[phone] = updated;
    return updated;
  }

  static UserProfile _rebuild(
    UserProfile p, {
    String? name,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goal,
    double? targetWeightKg,
    String? dietPref,
    double? bmr,
    double? tdee,
    double? dailyCalorieTarget,
  }) {
    return UserProfile(
      id: p.id,
      phone: p.phone,
      name: name ?? p.name,
      email: email ?? p.email,
      gender: gender ?? p.gender,
      dateOfBirth: dateOfBirth ?? p.dateOfBirth,
      heightCm: heightCm ?? p.heightCm,
      weightKg: weightKg ?? p.weightKg,
      activityLevel: activityLevel ?? p.activityLevel,
      goal: goal ?? p.goal,
      targetWeightKg: targetWeightKg ?? p.targetWeightKg,
      dietPref: dietPref ?? p.dietPref,
      bmr: bmr ?? p.bmr,
      tdee: tdee ?? p.tdee,
      dailyCalorieTarget: dailyCalorieTarget ?? p.dailyCalorieTarget,
      isPro: p.isPro,
    );
  }

  static double? _bmrFromProfile(UserProfile p) {
    if (p.weightKg == null || p.heightCm == null || p.dateOfBirth == null) {
      return null;
    }
    final age = p.age;
    if (age == null) return null;
    final isMale = (p.gender ?? '').toLowerCase() == 'male';
    // Mifflin-St Jeor
    final base = 10 * p.weightKg! + 6.25 * p.heightCm! - 5 * age;
    return isMale ? base + 5 : base - 161;
  }

  static double? _tdeeFromProfile(UserProfile p, double? bmr) {
    if (bmr == null) return null;
    final factor = switch ((p.activityLevel ?? 'sedentary').toLowerCase()) {
      'very_active' => 1.725,
      'active' => 1.55,
      'moderate' => 1.375,
      'light' => 1.2,
      _ => 1.0,
    };
    return bmr * factor;
  }

  static double _dailyCalorieTarget(UserProfile p, double? tdee) {
    if (tdee == null) return 2000;
    switch ((p.goal ?? 'maintain').toLowerCase()) {
      case 'lose':
        return tdee - 500;
      case 'gain':
        return tdee + 500;
      default:
        return tdee;
    }
  }

  // ----- Foods -----

  static Future<List<FoodItem>> listFoods({String? category}) async {
    final list = _kFoodLibrary
        .where((f) => category == null ? true : f.category == category)
        .toList();
    list.sort((a, b) => a.nameEn.compareTo(b.nameEn));
    return list;
  }

  // ----- Meals -----

  static Future<List<MealEntry>> listMeals({
    required DateTime date,
    String? mealType,
  }) async {
    final phone = _phone();
    final list = _meals[phone] ?? const [];
    final day = _normalize(date);
    return list.where((m) {
      if (!_sameDay(m.eatenOn, day)) return false;
      if (mealType != null && m.mealType != mealType) return false;
      return true;
    }).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  static Future<String> logMeal({
    required String foodId,
    required DateTime eatenOn,
    required String mealType,
    double servings = 1.0,
  }) async {
    final phone = _phone();
    final food = _findFood(foodId);
    if (food == null) {
      throw StateError('Unknown food: $foodId');
    }
    final entry = MealEntry(
      id: _genId('meal'),
      foodId: foodId,
      foodName: food.nameEn,
      mealType: mealType,
      servings: servings,
      eatenOn: eatenOn,
      kcalTotal: food.kcalPerServing * servings,
      proteinTotal: food.proteinG * servings,
      carbsTotal: food.carbsG * servings,
      fatTotal: food.fatG * servings,
      createdAt: DateTime.now(),
    );
    _meals.putIfAbsent(phone, () => []).add(entry);
    return entry.id;
  }

  static Future<void> deleteMeal(String id) async {
    final phone = _phone();
    final list = _meals[phone];
    if (list == null) return;
    list.removeWhere((m) => m.id == id);
  }

  // ----- Water -----

  static Future<WaterLog> getWater(DateTime date) async {
    final phone = _phone();
    final list = _water[phone] ?? const [];
    final day = _normalize(date);
    final entries = list.where((e) => _sameDay(e.loggedOn, day)).toList()
      ..sort((a, b) => a.loggedOn.compareTo(b.loggedOn));
    final total = entries.fold<int>(0, (s, e) => s + e.amountMl);
    final profile = _profiles[phone];
    final target = profile?.dailyCalorieTarget == null
        ? 2500
        : (profile!.weightKg == null
            ? 2500
            : (profile.weightKg! * 35).round().clamp(2000, 4000));
    return WaterLog(
      date: date,
      totalMl: total,
      targetMl: target,
      entries: entries,
    );
  }

  static Future<void> addWater(int amountMl) async {
    final phone = _phone();
    final now = DateTime.now();
    final entry = WaterEntry(
      id: _genId('water'),
      amountMl: amountMl,
      loggedOn: now,
      loggedAt: now,
    );
    _water.putIfAbsent(phone, () => []).add(entry);
  }

  static Future<void> deleteWater(String id) async {
    final phone = _phone();
    final list = _water[phone];
    if (list == null) return;
    list.removeWhere((e) => e.id == id);
  }

  // ----- Plan -----

  static Future<DailyPlan> getPlan({DateTime? date}) async {
    final phone = _phone();
    final p = _plans[phone];
    if (p != null) return p;
    // Default plan derived from profile.
    final profile = _profiles[phone];
    final kcal = profile?.dailyCalorieTarget ?? 2000;
    final water = profile?.weightKg == null
        ? 2500
        : (profile!.weightKg! * 35).round().clamp(2000, 4000);
    return DailyPlan(
      planDate: date ?? DateTime.now(),
      kcalTarget: kcal.toDouble(),
      waterMl: water,
    );
  }

  static Future<void> savePlan({
    required DateTime planDate,
    required double kcalTarget,
    required int waterMl,
    String? notes,
  }) async {
    final phone = _phone();
    _plans[phone] = DailyPlan(
      planDate: planDate,
      kcalTarget: kcalTarget,
      waterMl: waterMl,
      notes: notes,
    );
  }

  // ----- Progress -----

  static Future<ProgressReport> getProgress() async {
    final phone = _phone();
    final today = DateTime.now();
    final plan = await getPlan(date: today);
    final water = await getWater(today);
    final mealsToday = await listMeals(date: today);

    double kcalIn = 0, pIn = 0, cIn = 0, fIn = 0;
    for (final m in mealsToday) {
      kcalIn += m.kcalTotal;
      pIn += m.proteinTotal;
      cIn += m.carbsTotal;
      fIn += m.fatTotal;
    }

    final week = _buildWeek(phone, today);

    final profile = _profiles[phone];
    final streak = _streak(phone);

    final start = _firstWeight(phone);
    final current = _lastWeight(phone) ?? profile?.weightKg;
    final delta = (start != null && current != null) ? current - start : null;

    final kcalTarget = plan.kcalTarget;
    final waterTarget = plan.waterMl;
    final proteinGoal = (kcalTarget * 0.25 / 4);
    final carbsGoal = (kcalTarget * 0.50 / 4);
    final fatGoal = (kcalTarget * 0.25 / 9);

    return ProgressReport(
      today: {
        'kcal_in': kcalIn,
        'protein_in': pIn,
        'carbs_in': cIn,
        'fat_in': fIn,
        'water_ml': water.totalMl,
        'kcal_out': 0.0,
      },
      target: {
        'kcal': kcalTarget,
        'water_ml': waterTarget,
      },
      week: week,
      streak: streak,
      weight: {
        'start': start,
        'current': current,
        'delta': delta,
      },
      macros: {
        'protein_g': proteinGoal,
        'carbs_g': carbsGoal,
        'fat_g': fatGoal,
      },
    );
  }

  static List<Map<String, dynamic>> _buildWeek(String phone, DateTime today) {
    final meals = _meals[phone] ?? const [];
    final result = <Map<String, dynamic>>[];
    for (int i = 6; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      final day = _normalize(d);
      final kcal = meals
          .where((m) => _sameDay(m.eatenOn, day))
          .fold<double>(0, (s, m) => s + m.kcalTotal);
      result.add({
        'date':
            '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}',
        'kcal_in': kcal,
      });
    }
    return result;
  }

  static int _streak(String phone) {
    final meals = _meals[phone] ?? const [];
    if (meals.isEmpty) return 0;
    final today = _normalize(DateTime.now());
    int streak = 0;
    for (int i = 0; i < 30; i++) {
      final day = today.subtract(Duration(days: i));
      final has = meals.any((m) => _sameDay(m.eatenOn, day));
      if (has) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static double? _firstWeight(String phone) {
    final list = _weight[phone];
    if (list == null || list.isEmpty) return null;
    return (list.first['weight_kg'] as num?)?.toDouble();
  }

  static double? _lastWeight(String phone) {
    final list = _weight[phone];
    if (list == null || list.isEmpty) return null;
    return (list.last['weight_kg'] as num?)?.toDouble();
  }

  // ----- Activity (kept for API parity; no-op) -----

  static Future<void> logActivity({
    required String activity,
    required int durationMin,
    double? kcalBurned,
  }) async {
    // No-op in offline mode.
  }

  // ----- Weight -----

  static Future<void> logWeight(double kg, {DateTime? measuredOn}) async {
    final phone = _phone();
    final today = _normalize(measuredOn ?? DateTime.now());
    _weight.putIfAbsent(phone, () => []).add({
      'measured_on':
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
      'weight_kg': kg,
    });
    // Mirror into profile so the stat tile + progress card update.
    final p = _profiles[phone];
    if (p != null) {
      _profiles[phone] = _rebuild(p, weightKg: kg);
    }
  }
}
