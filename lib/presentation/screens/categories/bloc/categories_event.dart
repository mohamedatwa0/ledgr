import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

abstract class CategoriesEvent {
  const CategoriesEvent();
}

class CategoriesStarted extends CategoriesEvent {
  const CategoriesStarted();
}

class CategoriesTypeChanged extends CategoriesEvent {
  const CategoriesTypeChanged(this.type);

  final TransactionType type;
}

class CategoriesUpdated extends CategoriesEvent {
  const CategoriesUpdated(this.categories);

  final List<Category> categories;
}
