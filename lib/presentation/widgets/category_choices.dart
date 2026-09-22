import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CategoryIconChoice {
  const CategoryIconChoice(this.icon, this.label);

  final IconData icon;
  final String label;
}

const categoryIconChoices = <CategoryIconChoice>[
  CategoryIconChoice(TablerIcons.coffee, 'Coffee'),
  CategoryIconChoice(TablerIcons.shopping_bag, 'Shopping'),
  CategoryIconChoice(TablerIcons.car, 'Transit'),
  CategoryIconChoice(TablerIcons.book, 'Books'),
  CategoryIconChoice(TablerIcons.tools_kitchen_2, 'Dining'),
  CategoryIconChoice(TablerIcons.tools, 'Tools'),
  CategoryIconChoice(TablerIcons.home, 'Housing'),
  CategoryIconChoice(TablerIcons.music, 'Music'),
  CategoryIconChoice(TablerIcons.camera, 'Camera'),
  CategoryIconChoice(TablerIcons.plane, 'Travel'),
  CategoryIconChoice(TablerIcons.file_invoice, 'Invoice'),
  CategoryIconChoice(TablerIcons.heart, 'Health'),
  CategoryIconChoice(TablerIcons.movie, 'Movies'),
  CategoryIconChoice(TablerIcons.wallet, 'Wallet'),
  CategoryIconChoice(TablerIcons.briefcase, 'Work'),
  CategoryIconChoice(TablerIcons.arrows_exchange, 'Transfer'),
  CategoryIconChoice(TablerIcons.dots, 'Other'),
  CategoryIconChoice(TablerIcons.gift, 'Gift'),
  CategoryIconChoice(TablerIcons.phone, 'Phone'),
  CategoryIconChoice(TablerIcons.bolt, 'Utilities'),
  CategoryIconChoice(TablerIcons.gas_station, 'Fuel'),
  CategoryIconChoice(TablerIcons.building_bank, 'Bank'),
  CategoryIconChoice(TablerIcons.device_tv, 'TV'),
  CategoryIconChoice(TablerIcons.calendar, 'Calendar'),
  CategoryIconChoice(TablerIcons.tag, 'Tag'),
  CategoryIconChoice(TablerIcons.user, 'Personal'),
  CategoryIconChoice(TablerIcons.receipt, 'Receipt'),
];

String? categoryIconLabel(int codePoint) {
  for (final choice in categoryIconChoices) {
    if (choice.icon.codePoint == codePoint) return choice.label;
  }
  return null;
}

const categoryColorChoices = <int>[
  0xFF1A7C86,
  0xFF3D7A4A,
  0xFFD14B45,
  0xFF3E4C5C,
  0xFFE07A32,
  0xFF5346C8,
  0xFF8A6428,
];
