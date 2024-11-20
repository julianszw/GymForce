String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  return "$hours horas $minutes minutos";
}

double calculatePercentage(String current, String total) {
  final currentInt = int.tryParse(current) ?? 0;
  final totalInt = int.tryParse(total) ?? 0;

  if (totalInt == 0) {
    return 0.0;
  }

  final percent = currentInt / totalInt;

  if (percent > 1) {
    return 1;
  } else {
    return percent;
  }
}
