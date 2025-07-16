import 'package:bom_hamburguer/l10n/global_app_localizations.dart';
import 'package:bom_hamburguer/viewmodels/utils/routes/manager/app_main_routes_manager.dart';
import 'package:bom_hamburguer/services/database_service.dart';
import 'package:bom_hamburguer/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await init();
  await sl<DatabaseService>().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartService>(
      create: (_) => sl<CartService>(),
      child: MaterialApp.router(
        title: 'Bom Hambúrguer',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.orange,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ).copyWith(
            secondary: Colors.orange.shade600,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange),
            ),
          ),
        ),
        builder: (context, child) {
          sl<GlobalAppLocalizations>()
              .setAppLocalizations(AppLocalizations.of(context));

          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: child!,
          );
        },
      ),
    );
  }
}
