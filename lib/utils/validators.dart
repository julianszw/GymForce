bool validateEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  return password.length >= 6;
}

bool validateName(String name) {
  List<String> words = name.split(' ');
  if (words.length < 2) return false;

  for (String word in words) {
    if (word.length < 3) return false;
  }

  return true;
}
