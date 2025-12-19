import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/urun_ogesi.dart';
import 'models/alisveris_listesi.dart';

import 'services/list_provider.dart';
//import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init('${appDocumentDir.path}/hive_data_v2');

  Hive.registerAdapter(OncelikAdapter());
  Hive.registerAdapter(UrunOgesiAdapter());
  Hive.registerAdapter(KategoriAdapter());
  Hive.registerAdapter(AlisverisListesiAdapter());

  if (!Hive.isBoxOpen('lists')) {
    await Hive.openBox<AlisverisListesi>('lists');
  }

  if (!Hive.isBoxOpen('urunler')) {
    await Hive.openBox<UrunOgesi>('urunler');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const MaterialColor primaryColor = MaterialColor(0xFF3C3F8B, <int, Color>{
      50: Color(0xFFE6E6F2),
      100: Color(0xFFC0C1E0),
      200: Color(0xFF9497CB),
      300: Color(0xFF676DAC),
      400: Color(0xFF485698),
      500: Color(0xFF3C3F8B),
      600: Color(0xFF363983),
      700: Color(0xFF2E317A),
      800: Color(0xFF262972),
      900: Color(0xFF181D63),
    });

    return MaterialApp(
      title: 'Alışveriş Takip Listesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        useMaterial3: true,

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor.shade600,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
