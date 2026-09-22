import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../domain/exceptions.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';
import '../../../../domain/repositories/category_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/create_category.dart';
import '../../../../domain/usecases/delete_category.dart';
import '../../../../domain/usecases/update_category.dart';
import '../../../widgets/category_choices.dart';
import 'category_form_event.dart';
import 'category_form_state.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  CategoryFormBloc({
    required CategoryRepository categories,
    required TransactionRepository transactions,
    required CreateCategory createCategory,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
    this.categoryId,
    TransactionType type = TransactionType.expense,
  })  : _categories = categories,
        _transactions = transactions,
        _createCategory = createCategory,
        _updateCategory = updateCategory,
        _deleteCategory = deleteCategory,
        super(
          CategoryFormState(
            name: '',
            type: type,
            iconCodePoint: TablerIcons.coffee.codePoint,
            colorValue: categoryColorChoices.first,
            loading: categoryId != null,
          ),
        ) {
    on<CategoryFormStarted>(_onStarted);
    on<CategoryFormNameChanged>(_onNameChanged);
    on<CategoryFormTypeChanged>(_onTypeChanged);
    on<CategoryFormIconChanged>(_onIconChanged);
    on<CategoryFormColorChanged>(_onColorChanged);
    on<CategoryFormSaveRequested>(_onSaveRequested);
    on<CategoryFormDeletePressed>(_onDeletePressed);
    on<CategoryFormDeleteConfirmed>(_onDeleteConfirmed);
    on<CategoryFormDeleteDismissed>(_onDeleteDismissed);
  }

  final CategoryRepository _categories;
  final TransactionRepository _transactions;
  final CreateCategory _createCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;
  final int? categoryId;

  Future<void> _onStarted(
    CategoryFormStarted event,
    Emitter<CategoryFormState> emit,
  ) async {
    final id = categoryId;
    if (id == null) return;
    final category = await _categories.getById(id);
    if (isClosed) return;
    if (category == null) {
      emit(
        state.copyWith(
          loading: false,
          notFound: true,
          errorMessage: const CategoryNotFoundException().message,
        ),
      );
      return;
    }
    emit(
      CategoryFormState(
        name: category.name,
        type: category.type,
        iconCodePoint: category.iconCodePoint,
        colorValue: category.colorValue,
        isDefault: category.isDefault,
      ),
    );
  }

  void _onNameChanged(
    CategoryFormNameChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onTypeChanged(
    CategoryFormTypeChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(type: event.type));
  }

  void _onIconChanged(
    CategoryFormIconChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(iconCodePoint: event.iconCodePoint));
  }

  void _onColorChanged(
    CategoryFormColorChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(colorValue: event.colorValue));
  }

  Future<void> _onSaveRequested(
    CategoryFormSaveRequested event,
    Emitter<CategoryFormState> emit,
  ) async {
    if (!state.canSave) return;
    emit(state.copyWith(saving: true, saved: false, clearError: true));
    try {
      final id = categoryId;
      if (id == null) {
        final created = await _createCategory(
          name: state.name,
          type: state.type,
          iconCodePoint: state.iconCodePoint,
          colorValue: state.colorValue,
        );
        if (!isClosed) {
          emit(
            state.copyWith(
              saving: false,
              saved: true,
              savedCategoryId: created.id,
            ),
          );
        }
        return;
      } else {
        await _updateCategory(
          Category(
            id: id,
            name: state.name,
            type: state.type,
            iconCodePoint: state.iconCodePoint,
            colorValue: state.colorValue,
            isDefault: false,
          ),
        );
      }
      if (!isClosed) emit(state.copyWith(saving: false, saved: true));
    } on LedgrException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(saving: false, errorMessage: e.message));
      }
    }
  }

  Future<void> _onDeletePressed(
    CategoryFormDeletePressed event,
    Emitter<CategoryFormState> emit,
  ) async {
    final id = categoryId;
    if (id == null) return;
    final count = await _transactions.countForCategory(id);
    if (!isClosed) emit(state.copyWith(deletePromptCount: count));
  }

  Future<void> _onDeleteConfirmed(
    CategoryFormDeleteConfirmed event,
    Emitter<CategoryFormState> emit,
  ) async {
    final id = categoryId;
    if (id == null) return;
    emit(state.copyWith(clearDeletePrompt: true, clearError: true));
    try {
      await _deleteCategory(id);
      if (!isClosed) emit(state.copyWith(deleted: true));
    } on LedgrException catch (e) {
      if (!isClosed) emit(state.copyWith(errorMessage: e.message));
    }
  }

  void _onDeleteDismissed(
    CategoryFormDeleteDismissed event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(clearDeletePrompt: true));
  }
}
