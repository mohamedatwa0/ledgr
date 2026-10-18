import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../l10n/app_localizations.dart';

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

String? localizedCategoryIconLabel(AppLocalizations l10n, String? label) {
  switch (label) {
    case 'Coffee':
      return l10n.iconCoffee;
    case 'Shopping':
      return l10n.iconShopping;
    case 'Transit':
      return l10n.iconTransit;
    case 'Books':
      return l10n.iconBooks;
    case 'Dining':
      return l10n.iconDining;
    case 'Tools':
      return l10n.iconTools;
    case 'Housing':
      return l10n.iconHousing;
    case 'Music':
      return l10n.iconMusic;
    case 'Camera':
      return l10n.iconCamera;
    case 'Travel':
      return l10n.iconTravel;
    case 'Invoice':
      return l10n.iconInvoice;
    case 'Health':
      return l10n.iconHealth;
    case 'Movies':
      return l10n.iconMovies;
    case 'Wallet':
      return l10n.iconWallet;
    case 'Work':
      return l10n.iconWork;
    case 'Transfer':
      return l10n.iconTransfer;
    case 'Other':
      return l10n.iconOther;
    case 'Gift':
      return l10n.iconGift;
    case 'Phone':
      return l10n.iconPhone;
    case 'Utilities':
      return l10n.iconUtilities;
    case 'Fuel':
      return l10n.iconFuel;
    case 'Bank':
      return l10n.iconBank;
    case 'TV':
      return l10n.iconTv;
    case 'Calendar':
      return l10n.iconCalendar;
    case 'Tag':
      return l10n.iconTag;
    case 'Personal':
      return l10n.iconPersonal;
    case 'Receipt':
      return l10n.iconReceipt;
    default:
      return label;
  }
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
