/// Centered placeholder copy for the speech-to-text / translate page.
class SttHintStrings {
  SttHintStrings._();

  static String sourceSpeech(String languageName) =>
      'Your $languageName speech will appear here';

  static String targetTranslation(String languageName) =>
      'Your $languageName translation will appear here';
}
