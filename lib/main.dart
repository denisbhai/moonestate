import 'package:flutter/material.dart';
import 'package:moonestate/screens/auth/register_screen.dart';
import 'package:moonestate/screens/auth/splash_screen.dart';
import 'package:moonestate/screens/home/home_screen.dart';
import 'package:moonestate/screens/home/map_view_screen.dart';
import 'package:moonestate/screens/home/property_detail_screen.dart';
import 'package:moonestate/screens/notifications_screen.dart';
import 'package:moonestate/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/property.dart';
import 'providers/auth_provider.dart';
import 'providers/property_provider.dart';
import 'providers/language_provider.dart';
import 'services/notification_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/property_list_screen.dart';
import 'utils/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Moonestate',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: languageProvider.currentLocale,
            supportedLocales: languageProvider.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: SplashScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/register': (context) => RegisterScreen(),
              '/properties': (context) => PropertyListScreen(),
              '/home': (context) => HomeScreen(),
              '/property-detail': (context) {
                final id = ModalRoute.of(context)!.settings.arguments as int;
                return PropertyDetailScreen(id: id);
              },
              '/map-view': (context) {
                final properties = ModalRoute.of(context)!.settings.arguments as List<PropertyElement>;
                return MapViewScreen(properties: properties);
              },
              '/profile': (context) => ProfileScreen(),
              '/notifications': (context) => NotificationsScreen(),
            },
          );
        },
      ),
    );
  }
}