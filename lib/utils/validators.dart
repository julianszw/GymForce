import 'package:intl/intl.dart';

bool validateEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  final passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,25}$');

  return passwordRegex.hasMatch(password);
}

bool validateName(String name) {
  List<String> words = name.split(' ');
  if (words.length < 2) return false;

  for (String word in words) {
    if (word.length < 3) return false;
  }

  return true;
}

bool validateAddress(String location) {
  final RegExp invalidChars = RegExp(r'[^a-zA-Z0-9\s]');
  if (invalidChars.hasMatch(location)) return false;

  final RegExp hasWordWithThreeLetters = RegExp(r'\b[a-zA-Z]{3,}\b');
  if (!hasWordWithThreeLetters.hasMatch(location)) return false;

  final RegExp numbersPattern = RegExp(r'\b\d{1,5}\b');
  final Iterable<Match> matches = numbersPattern.allMatches(location);
  final List<int> numbers =
      matches.map((match) => int.parse(match.group(0)!)).toList();

  if (numbers.isEmpty || numbers.any((n) => n > 20000)) return false;

  final RegExp hasInvalidMixedWords = RegExp(r'\b[a-zA-Z]+\d+|\d+[a-zA-Z]+\b');
  if (hasInvalidMixedWords.hasMatch(location)) return false;

  return true;
}

bool validateDni(String dni) {
  dni = dni.trim();

  final argentinaRegex = RegExp(r'^\d{7,8}$');

  final extranjeroRegex = RegExp(r'^[a-zA-Z0-9\-]{6,20}$');

  return argentinaRegex.hasMatch(dni) || extranjeroRegex.hasMatch(dni);
}

bool validatePhoneNumber(String phone) {
  final regex = RegExp(r'^(11|15)\d{8}$');
  return regex.hasMatch(phone);
}

bool validateAge(String birthDateString) {
  if (birthDateString.isEmpty) return false;

  final dateFormat = DateFormat("d 'de' MMMM 'del' yyyy", "es");

  try {
    final birthDate = dateFormat.parse(birthDateString);
    final today = DateTime.now();

    int age = today.year - birthDate.year;

    bool hasHadBirthdayThisYear = today.month > birthDate.month ||
        (today.month == birthDate.month && today.day >= birthDate.day);

    if (!hasHadBirthdayThisYear) {
      age--;
    }

    return age >= 18;
  } catch (e) {
    print("Error al analizar la fecha: $e");
    return false;
  }
}
