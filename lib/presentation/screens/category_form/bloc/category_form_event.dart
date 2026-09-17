import '../../../../domain/models/transaction_type.dart';

abstract class CategoryFormEvent {
  const CategoryFormEvent();
}

class CategoryFormStarted extends CategoryFormEvent {
  const CategoryFormStarted();
}

class CategoryFormNameChanged extends CategoryFormEvent {
  const CategoryFormNameChanged(this.name);

  final String name;
}

class CategoryFormTypeChanged extends CategoryFormEvent {
  const CategoryFormTypeChanged(this.type);

  final TransactionType type;
}

class CategoryFormIconChanged extends CategoryFormEvent {
  const CategoryFormIconChanged(this.iconCodePoint);

  final int iconCodePoint;
}

class CategoryFormColorChanged extends CategoryFormEvent {
  const CategoryFormColorChanged(this.colorValue);

  final int colorValue;
}

class CategoryFormSaveRequested extends CategoryFormEvent {
  const CategoryFormSaveRequested();
}

class CategoryFormDeletePressed extends CategoryFormEvent {
  const CategoryFormDeletePressed();
}

class CategoryFormDeleteConfirmed extends CategoryFormEvent {
  const CategoryFormDeleteConfirmed();
}

class CategoryFormDeleteDismissed extends CategoryFormEvent {
  const CategoryFormDeleteDismissed();
}
