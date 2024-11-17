String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  return "$hours horas $minutes minutos";
}
