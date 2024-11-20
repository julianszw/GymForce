import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/daily_calories_domain.dart';

class DailyCaloriesNotifier extends StateNotifier<Map<String, dynamic>> {
  DailyCaloriesNotifier()
      : super({
          'dailyCalories': <DailyCalories>[],
          'totalProteins': '0',
          'totalCalories': '0',
          'totalCarbs': '0',
          'totalFats': '0',
        });

  void addDailyCalories(DailyCalories dailyCalories) {
    final newDailyCalories =
        List<DailyCalories>.from(state['dailyCalories'] as List<DailyCalories>)
          ..add(dailyCalories);

    state = {
      'dailyCalories': newDailyCalories,
      'totalProteins': _calculateTotalProteins(newDailyCalories),
      'totalCalories': _calculateTotalCalories(newDailyCalories),
      'totalCarbs': _calculateTotalCarbs(newDailyCalories),
      'totalFats': _calculateTotalFats(newDailyCalories),
    };
  }

  void setDailyCaloriesList(List<DailyCalories> dailyCaloriesList) {
    state = {
      'dailyCalories': dailyCaloriesList,
      'totalProteins': _calculateTotalProteins(dailyCaloriesList),
      'totalCalories': _calculateTotalCalories(dailyCaloriesList),
      'totalCarbs': _calculateTotalCarbs(dailyCaloriesList),
      'totalFats': _calculateTotalFats(dailyCaloriesList),
    };
  }

  String _calculateTotalProteins(List<DailyCalories> dailyCaloriesList) {
    return dailyCaloriesList.fold(0, (sum, item) {
      return sum + (int.tryParse(item.proteins) ?? 0);
    }).toString();
  }

  String _calculateTotalCalories(List<DailyCalories> dailyCaloriesList) {
    return dailyCaloriesList.fold(0, (sum, item) {
      return sum + (int.tryParse(item.calories) ?? 0);
    }).toString();
  }

  String _calculateTotalCarbs(List<DailyCalories> dailyCaloriesList) {
    return dailyCaloriesList.fold(0, (sum, item) {
      return sum + (int.tryParse(item.carbs) ?? 0);
    }).toString();
  }

  String _calculateTotalFats(List<DailyCalories> dailyCaloriesList) {
    return dailyCaloriesList.fold(0, (sum, item) {
      return sum + (int.tryParse(item.fats) ?? 0);
    }).toString();
  }
}

final dailyCaloriesProvider =
    StateNotifierProvider<DailyCaloriesNotifier, Map<String, dynamic>>(
  (ref) => DailyCaloriesNotifier(),
);
