enum MainRoutes {
  home('/home'),
  checkout('/checkout');

  const MainRoutes(this.route);

  final String route;

  String get name => toString().split('.').last;
}
