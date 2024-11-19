import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

int calculateCalories({
  required double weight,
  required double height,
  required String activityLevel,
  required String birthdate,
  required String gender,
  required String goal,
}) {
  initializeDateFormatting('es', null);

  DateTime birthDate;

  DateFormat dateFormat = DateFormat("d 'de' MMMM 'del' yyyy", 'es');
  birthDate = dateFormat.parse(birthdate);

  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  if (currentDate.month < birthDate.month ||
      (currentDate.month == birthDate.month &&
          currentDate.day < birthDate.day)) {
    age--;
  }

  double bmr;
  if (gender == 'Masculino') {
    bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
  } else if (gender == 'Femenino' || gender == 'Otro') {
    bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
  } else {
    return 0;
  }

  double tdee;
  switch (activityLevel) {
    case 'Sedentario':
      tdee = bmr * 1.2;
      break;
    case 'Ligero':
      tdee = bmr * 1.375;
      break;
    case 'Moderado':
      tdee = bmr * 1.55;
      break;
    case 'Intenso':
      tdee = bmr * 1.725;
      break;
    case 'Muy intenso':
      tdee = bmr * 1.9;
      break;
    default:
      tdee = bmr * 1.2;
  }

  if (goal == 'Ganancia muscular') {
    tdee *= 1.15;
  } else if (goal == 'Pérdida de peso') {
    tdee *= 0.85;
  }

  return tdee.toInt();
}
