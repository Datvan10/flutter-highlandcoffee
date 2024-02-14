class LanguageTranslator {
  Map<String, String> englishToVietnamese = {
    'tea': 'trà',
    'coffee': 'phin',
    'cake' : 'bánh',
    'americano': 'americano',
    'cappuccino' : 'cappuccino'
    // Add more translations as needed
  };

  String translate(String englishWord) {
    String translatedWord = englishToVietnamese[englishWord.toLowerCase()] ?? englishWord;
    return translatedWord.toUpperCase();
  }
}
