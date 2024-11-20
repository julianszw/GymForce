import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/calories_domain.dart';

class DailyCaloriesNotifier extends StateNotifier<Calories> {
  DailyCaloriesNotifier()
      : super(Calories(
          userId: '',
          calories: '0',
          proteins: '0',
          carbs: '0',
          fats: '0',
          date: DateTime.now(),
        ));

  void addDailyCalories(Calories dailyCalories) {
    final DateTime today = DateTime.now();

    if (state.date == null || !_isSameDate(state.date!, today)) {
      state = Calories(
        userId: state.userId,
        calories: '0',
        proteins: '0',
        carbs: '0',
        fats: '0',
        date: today,
      );
    }

    state = Calories(
      userId: state.userId,
      calories: (int.parse(state.calories) + int.parse(dailyCalories.calories))
          .toString(),
      proteins: (int.parse(state.proteins) + int.parse(dailyCalories.proteins))
          .toString(),
      carbs:
          (int.parse(state.carbs) + int.parse(dailyCalories.carbs)).toString(),
      fats: (int.parse(state.fats) + int.parse(dailyCalories.fats)).toString(),
      date: today,
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

final dailyCaloriesProvider =
    StateNotifierProvider<DailyCaloriesNotifier, Calories>(
  (ref) => DailyCaloriesNotifier(),
);
