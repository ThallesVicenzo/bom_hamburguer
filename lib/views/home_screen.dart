import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/viewmodels/product_viewmodel.dart';
import 'package:bom_hamburguer/views/widgets/app_bar_with_cart.dart';
import 'package:bom_hamburguer/views/widgets/welcome_section.dart';
import 'package:bom_hamburguer/views/widgets/product_section.dart';
import 'package:bom_hamburguer/views/widgets/promotion_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: const AppBarWithCart(),
      body: productViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WelcomeSection(),
                  const SizedBox(height: 24),
                  ProductSection(
                    title: l10n.sandwiches,
                    products: productViewModel.sandwiches,
                  ),
                  const SizedBox(height: 24),
                  ProductSection(
                    title: l10n.extras,
                    products: productViewModel.extras,
                  ),
                  const SizedBox(height: 24),
                  const PromotionInfo(),
                ],
              ),
            ),
    );
  }
}
