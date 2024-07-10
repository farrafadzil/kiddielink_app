import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddielink_app/screen/Welcome/onboarding_screen.dart';
import 'package:kiddielink_app/theme/provider.dart';
import 'package:month_year_picker2/month_year_picker2.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.instance.requestPermission();
  String? token = await messaging.getToken();
  print('FCM Token: $token');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>UiProvider()..init() ,
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: notifier.isDark? ThemeMode.dark : ThemeMode.light,

            // custom theme applied
            darkTheme: notifier.isDark? notifier.darkTheme : notifier.lightTheme ,
            home:const WelcomeScreen(),
            localizationsDelegates: const [
              MonthYearPickerLocalizations.delegate,
            ],
          );
        }
      ),
    );
  }
}