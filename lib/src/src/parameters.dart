String fromEnum(Object enumeration) {
  assert(enumeration != null, 'Enumeration object cannot be null');
  return enumeration.toString().split('.').last;
}

enum SupportedLanguage {
  de,
  en,
  en_AU,
  en_CA,
  en_GB,
  en_IE,
  en_NZ,
  es,
  fr,
  fr_BE,
  fr_CA,
  it,
  ja_JP,
  nl,
  nl_BE,
  pl,
}

SupportedLanguage parseLanguage(String parameter) {
  final language = parameter.toLowerCase();
  switch (language) {
    case 'de':
    case 'de_de':
      return SupportedLanguage.de;
    case 'en':
    case 'en_us':
      return SupportedLanguage.en;
    case 'en_au':
      return SupportedLanguage.en_AU;
    case 'en_ca':
      return SupportedLanguage.en_CA;
    case 'en_gb':
      return SupportedLanguage.en_GB;
    case 'en_ie':
      return SupportedLanguage.en_IE;
    case 'en_nz':
      return SupportedLanguage.en_NZ;
    case 'es':
    case 'es_es':
      return SupportedLanguage.es;
    case 'fr':
    case 'fr_fr':
      return SupportedLanguage.fr;
    case 'fr_be':
      return SupportedLanguage.fr_BE;
    case 'fr_ca':
      return SupportedLanguage.fr_CA;
    case 'it':
    case 'it_it':
      return SupportedLanguage.it;
    case 'jp':
    case 'ja_jp':
    case 'ja':
      return SupportedLanguage.ja_JP;
    case 'nl':
    case 'nl_nl':
      return SupportedLanguage.nl;
    case 'nl_be':
      return SupportedLanguage.nl_BE;
    case 'pl':
    case 'pl_pl':
      return SupportedLanguage.pl;
    default:
      return null;
  }
}

enum TestPlatform {
  android,
  iOS,
}

TestPlatform platformFromString(String value) {
  switch (value?.toLowerCase()) {
    case 'android':
      return TestPlatform.android;
    case 'ios':
      return TestPlatform.iOS;
    default:
      return null;
  }
}
