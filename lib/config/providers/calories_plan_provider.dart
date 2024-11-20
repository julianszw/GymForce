import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/calories_domain.dart';

class CaloriesPlanNotifier extends StateNotifier<Calories> {
  CaloriesPlanNotifier()
      : super(Calories(
          userId: '',
          date: DateTime.now(),
          calories: '',
          proteins: '',
          carbs: '',
          fats: '',
        ));

  void setCaloriesPlan(Calories caloriesPlan) {
    state = caloriesPlan;
  }
}

final caloriesPlanProvider =
    StateNotifierProvider<CaloriesPlanNotifier, Calories>(
  (ref) => CaloriesPlanNotifier(),
);
