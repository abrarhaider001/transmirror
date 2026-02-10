import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/view/authentication/login.dart';
import 'package:transmirror/view/authentication/forgot_password.dart';
import 'package:transmirror/view/authentication/register.dart';
import 'package:transmirror/core/widgets/navbar/navbar.dart';
import 'package:transmirror/view/main/tts/download_models.dart';
import 'package:transmirror/view/splash.dart';
import 'package:transmirror/view/main/notes/text_note.dart';
import 'package:transmirror/view/main/tts/text_to_speech.dart';
import 'package:transmirror/view/main/ai_response/ai_response.dart';
import 'package:transmirror/view/main/stt/voice_listening.dart';
import 'package:transmirror/view/main/notes/create_note.dart';
import 'package:transmirror/view/main/ocr/image_selection_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const Splash()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(
      name: AppRoutes.home,
      page: () {
        final idxParam = int.tryParse(Get.parameters['index'] ?? '');
        final tabParam = Get.parameters['tab'];
        final idx = idxParam ?? (tabParam == 'chat' ? 2 : 0);
        return Navbar(initialIndex: idx);
      },
    ),
    GetPage(name: AppRoutes.textNote, page: () => const TextNotePage()),
    GetPage(name: AppRoutes.textToSpeech, page: () => const TextToSpeechPage()),
    GetPage(name: AppRoutes.aiResponse, page: () => const AiResponsePage()),
    GetPage(name: AppRoutes.speechToText, page: () => const VoiceListeningPage()),
    GetPage(name: AppRoutes.createNote, page: () => const CreateNotePage()),
    GetPage(name: AppRoutes.downloadModels, page: () => const DownloadModelsPage()),
    GetPage(name: AppRoutes.imageSelection, page: () => const ImageSelectionPage()),
  ];
}
