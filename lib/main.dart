import 'package:flutter/material.dart';
import 'package:planner_app/data/model/color.dart';
import 'package:planner_app/widget/theme_provider.dart';
import 'package:provider/provider.dart';
import 'screen/welcome_screen.dart'; // Import your initial screen

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(), // ThemeNotifier for theme management
        ),
        ChangeNotifierProvider(
          create: (context) => ColorProvider(), // ColorProvider for color management
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final colorProvider = Provider.of<ColorProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: colorProvider.appColor, // AppBar color from provider
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorProvider.appColor, // Button color from provider
          ),
        ),
        scaffoldBackgroundColor: colorProvider.backgroundColor, // Background color from provider
        brightness: themeNotifier.isDarkMode
            ? Brightness.dark
            : Brightness.light, // Brightness based on theme
      ),
      home: const WelcomeScreen(), // Set the initial screen
    );
  }
}
