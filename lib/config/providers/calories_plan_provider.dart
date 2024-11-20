import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/calorie_plan_domain.dart';

class CaloriePlanNotifier extends StateNotifier<CaloriePlan> {
  CaloriePlanNotifier()
      : super(CaloriePlan(
          id: null,
          userId: '',
          date: DateTime.now(),
          calories: '',
          proteins: '',
          carbs: '',
          fats: '',
        ));

  void setCaloriePlan(CaloriePlan caloriePlan) {
    state = caloriePlan;
  }

  void resetCaloriePlan() {
    state = CaloriePlan(
      id: null,
      userId: '',
      date: DateTime.now(),
      calories: '',
      proteins: '',
      carbs: '',
      fats: '',
    );
  }
}

final caloriePlanProvider =
    StateNotifierProvider<CaloriePlanNotifier, CaloriePlan>(
  (ref) => CaloriePlanNotifier(),
);
