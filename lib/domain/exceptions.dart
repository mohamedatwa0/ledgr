class LedgrException implements Exception {
  const LedgrException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ValidationException extends LedgrException {
  const ValidationException(super.message);
}

class DuplicateCategoryException extends LedgrException {
  const DuplicateCategoryException()
      : super('A category with that name already exists.');
}

class DefaultCategoryException extends LedgrException {
  const DefaultCategoryException()
      : super('Default categories cannot be changed or deleted.');
}

class SmsNotFoundException extends LedgrException {
  const SmsNotFoundException() : super('That SMS is no longer in the inbox.');
}

class SmsAlreadyImportedException extends LedgrException {
  const SmsAlreadyImportedException()
      : super('This SMS has already been added to the ledger.');
}

class TransactionNotFoundException extends LedgrException {
  const TransactionNotFoundException()
      : super('This entry is no longer in the ledger.');
}

class CategoryNotFoundException extends LedgrException {
  const CategoryNotFoundException()
      : super('This category is no longer available.');
}
