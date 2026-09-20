import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/exam_controller.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/exam_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DrivingRulesApp());
}

class DrivingRulesApp extends StatelessWidget {
  const DrivingRulesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ច្បាប់ចរាចរណ៍កម្ពុជា',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(
          name: '/exam',
          page: () => const ExamScreen(),
          binding: BindingsBuilder(() => Get.put(ExamController())),
        ),
      ],
      initialRoute: '/',
    );
  }
}
