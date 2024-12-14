import 'package:intl/intl.dart';

bool validateEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  final passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d\S]{8,25}$');

  return passwordRegex.hasMatch(password);
}

bool validateName(String name) {
  // Eliminar espacios al inicio y al final del nombre
  name = name.trim();

  List<String> words = name.split(' ');

  // Validar que tenga al menos dos palabras
  if (words.length < 2) return false;

  // Verificar que cada palabra tenga al menos 3 caracteres
  for (String word in words) {
    if (word.trim().length < 3) return false;
  }

  return true;
}

bool validateAddress(String location) {
  // Permitir letras, dígitos, espacios y caracteres especiales válidos (acentos, ñ, ü)
  final RegExp invalidChars = RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚüÜñÑ0-9\s]');
  if (invalidChars.hasMatch(location)) return false;

  // Verificar si hay al menos una palabra de 3 letras o más
  final RegExp hasWordWithThreeLetters =
      RegExp(r'\b[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]{3,}\b');
  if (!hasWordWithThreeLetters.hasMatch(location)) return false;

  // Verificar si contiene un número entre 1 y 20000
  final RegExp numbersPattern = RegExp(r'\b\d{1,5}\b');
  final Iterable<Match> matches = numbersPattern.allMatches(location);
  final List<int> numbers =
      matches.map((match) => int.parse(match.group(0)!)).toList();

  if (numbers.isEmpty || numbers.any((n) => n > 20000)) return false;

  // Evitar combinaciones inválidas de palabras mezcladas con números
  final RegExp hasInvalidMixedWords =
      RegExp(r'\b[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]+\d+|\d+[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]+\b');
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

    if (age < 18 || age > 110) {
      return false;
    }

    return true;
  } catch (e) {
    print("Error al analizar la fecha: $e");
    return false;
  }
}
