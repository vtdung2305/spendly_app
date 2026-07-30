import 'package:flutter/material.dart';

/// Maps the design handoff's Material icon-name strings (`iconLibrary`,
/// `DEFAULT_CATEGORIES`) to Flutter [IconData], and mirrors its 5 icon
/// groups + 6-swatch color palette used on the Create/Edit Category screen.
/// Kept out of domain since [Category] only stores the icon-name string.

const List<String> categoryColorOptions = [
  '#4F46E5',
  '#F59E0B',
  '#22C55E',
  '#F43F5E',
  '#8B5CF6',
  '#0EA5E9',
];

/// Internal group keys — display label comes from l10n
/// (`categoryIconGroupXxx`), independent from the icon-name strings below.
const List<String> categoryIconGroupKeys = [
  'food',
  'shopping',
  'transport',
  'home',
  'other',
];

const Map<String, List<String>> categoryIconGroups = {
  'food': [
    'restaurant',
    'local_cafe',
    'fastfood',
    'local_bar',
    'icecream',
    'bakery_dining',
    'ramen_dining',
    'local_pizza',
    'liquor',
    'egg_alt',
  ],
  'shopping': [
    'shopping_bag',
    'shopping_cart',
    'storefront',
    'redeem',
    'local_mall',
    'checkroom',
    'diamond',
    'watch',
    'local_florist',
    'card_giftcard',
  ],
  'transport': [
    'directions_car',
    'two_wheeler',
    'local_gas_station',
    'flight',
    'train',
    'directions_bus',
    'local_taxi',
    'pedal_bike',
    'local_parking',
    'directions_boat',
  ],
  'home': [
    'home',
    'bolt',
    'water_drop',
    'wifi',
    'cleaning_services',
    'chair',
    'tv',
    'local_laundry_service',
    'build',
    'pets',
  ],
  'other': [
    'medical_services',
    'school',
    'sports_esports',
    'fitness_center',
    'savings',
    'payments',
    'favorite',
    'celebration',
    'work',
    'more_horiz',
  ],
};

const Map<String, IconData> _kIconMap = {
  'restaurant': Icons.restaurant_rounded,
  'local_cafe': Icons.local_cafe_rounded,
  'fastfood': Icons.fastfood_rounded,
  'local_bar': Icons.local_bar_rounded,
  'icecream': Icons.icecream_rounded,
  'bakery_dining': Icons.bakery_dining_rounded,
  'ramen_dining': Icons.ramen_dining_rounded,
  'local_pizza': Icons.local_pizza_rounded,
  'liquor': Icons.liquor_rounded,
  'egg_alt': Icons.egg_alt_rounded,
  'shopping_bag': Icons.shopping_bag_rounded,
  'shopping_cart': Icons.shopping_cart_rounded,
  'storefront': Icons.storefront_rounded,
  'redeem': Icons.redeem_rounded,
  'local_mall': Icons.local_mall_rounded,
  'checkroom': Icons.checkroom_rounded,
  'diamond': Icons.diamond_rounded,
  'watch': Icons.watch_rounded,
  'local_florist': Icons.local_florist_rounded,
  'card_giftcard': Icons.card_giftcard_rounded,
  'directions_car': Icons.directions_car_rounded,
  'two_wheeler': Icons.two_wheeler_rounded,
  'local_gas_station': Icons.local_gas_station_rounded,
  'flight': Icons.flight_rounded,
  'train': Icons.train_rounded,
  'directions_bus': Icons.directions_bus_rounded,
  'local_taxi': Icons.local_taxi_rounded,
  'pedal_bike': Icons.pedal_bike_rounded,
  'local_parking': Icons.local_parking_rounded,
  'directions_boat': Icons.directions_boat_rounded,
  'home': Icons.home_rounded,
  'bolt': Icons.bolt_rounded,
  'water_drop': Icons.water_drop_rounded,
  'wifi': Icons.wifi_rounded,
  'cleaning_services': Icons.cleaning_services_rounded,
  'chair': Icons.chair_rounded,
  'tv': Icons.tv_rounded,
  'local_laundry_service': Icons.local_laundry_service_rounded,
  'build': Icons.build_rounded,
  'pets': Icons.pets_rounded,
  'medical_services': Icons.medical_services_rounded,
  'school': Icons.school_rounded,
  'sports_esports': Icons.sports_esports_rounded,
  'fitness_center': Icons.fitness_center_rounded,
  'savings': Icons.savings_rounded,
  'payments': Icons.payments_rounded,
  'favorite': Icons.favorite_rounded,
  'celebration': Icons.celebration_rounded,
  'work': Icons.work_rounded,
  'more_horiz': Icons.more_horiz_rounded,
};

/// Falls back to a generic tag icon for any name not in the library (should
/// not happen for categories created through the picker, but custom rows
/// seeded before an icon-set change would otherwise crash).
IconData categoryIconFor(String iconName) =>
    _kIconMap[iconName] ?? Icons.category_rounded;

Color categoryColorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}
