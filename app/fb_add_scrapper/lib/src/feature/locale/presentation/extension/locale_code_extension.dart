extension LocaleCodeExtension on String {
  String get languageName {
    switch (this) {
      case 'en':
        return 'English';
      case 'nl':
        return 'Dutch';
      default:
        return 'Unknown Language';
    }
  }
}
