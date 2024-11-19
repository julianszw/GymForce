import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/calories_plan_domain.dart';

class CaloriesPlanNotifier extends StateNotifier<CaloriesPlan> {
  CaloriesPlanNotifier()
      : super(CaloriesPlan(
          userId: '',
          date: DateTime.now(),
          calories: '',
          proteins: '',
          carbs: '',
          fats: '',
        ));

  void setCaloriesPlan(CaloriesPlan caloriesPlan) {
    state = caloriesPlan;
  }
}

final caloriesPlanProvider =
    StateNotifierProvider<CaloriesPlanNotifier, CaloriesPlan>(
  (ref) => CaloriesPlanNotifier(),
);
