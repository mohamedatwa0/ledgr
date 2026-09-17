import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';
import '../../../../domain/repositories/category_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required CategoryRepository categories})
      : _categories = categories,
        super(CategoriesState.initial) {
    on<CategoriesStarted>(_onStarted);
    on<CategoriesTypeChanged>(_onTypeChanged);
    on<CategoriesUpdated>(_onUpdated);
  }

  final CategoryRepository _categories;
  StreamSubscription<List<Category>>? _subscription;

  void _onStarted(CategoriesStarted event, Emitter<CategoriesState> emit) {
    _watch(state.type);
  }

  void _onTypeChanged(
    CategoriesTypeChanged event,
    Emitter<CategoriesState> emit,
  ) {
    if (event.type == state.type) return;
    emit(state.copyWith(type: event.type, loading: true));
    _watch(event.type);
  }

  void _onUpdated(CategoriesUpdated event, Emitter<CategoriesState> emit) {
    emit(state.copyWith(categories: event.categories, loading: false));
  }

  void _watch(TransactionType type) {
    _subscription?.cancel();
    _subscription = _categories.watchByType(type).listen((categories) {
      if (!isClosed) add(CategoriesUpdated(categories));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
