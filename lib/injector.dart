import 'package:bom_hamburguer/l10n/global_app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';
import 'package:bom_hamburguer/services/database_service.dart';
import 'package:bom_hamburguer/services/cart_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<GlobalAppLocalizations>(GlobalAppLocalizationsImpl());

  sl.registerSingleton<DatabaseService>(DatabaseServiceImpl());

  sl.registerFactory<ProductRepository>(() => ProductRepositoryImpl(sl()));

  sl.registerSingleton<CartService>(CartService(sl()));
}
