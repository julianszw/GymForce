import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/daily_calories_domain.dart';

class DailyCaloriesNotifier extends StateNotifier<List<DailyCalories>> {
  DailyCaloriesNotifier() : super([]);

  // Agregar un nuevo registro diario de calorías
  void addDailyCalories(DailyCalories dailyCalories) {
    state = [...state, dailyCalories];
  }

  // Actualizar un registro diario por ID del plan
  void updateDailyCalories(String planId, DailyCalories updatedCalories) {
    state = state.map((dailyCalories) {
      return dailyCalories.planId == planId ? updatedCalories : dailyCalories;
    }).toList();
  }

  // Eliminar un registro diario por ID del plan
  void deleteDailyCalories(String planId) {
    state = state.where((dailyCalories) => dailyCalories.planId != planId).toList();
  }
}

// Provider global para gestionar el estado de las calorías diarias
final dailyCaloriesProvider =
    StateNotifierProvider<DailyCaloriesNotifier, List<DailyCalories>>((ref) {
  return DailyCaloriesNotifier();
});
