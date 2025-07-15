import 'package:bom_hamburguer/l10n/global_app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';
import 'package:bom_hamburguer/viewmodels/product_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository());

  sl.registerSingleton<GlobalAppLocalizations>(GlobalAppLocalizationsImpl());

  sl.registerFactory<ProductViewModel>(() => ProductViewModel(sl()));
  sl.registerFactory<CartViewModel>(() => CartViewModel());
}
