import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/create_transaction.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/update_transaction.dart';
import '../screens/add_transaction/add_transaction_screen.dart';
import '../screens/add_transaction/bloc/add_transaction_bloc.dart';
import '../screens/add_transaction/bloc/add_transaction_event.dart';
import '../screens/categories/bloc/categories_bloc.dart';
import '../screens/categories/bloc/categories_event.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/category_form/bloc/category_form_bloc.dart';
import '../screens/category_form/bloc/category_form_event.dart';
import '../screens/category_form/category_form_screen.dart';
import '../screens/history/bloc/history_bloc.dart';
import '../screens/history/bloc/history_event.dart';
import '../screens/history/history_screen.dart';
import '../screens/home/bloc/home_bloc.dart';
import '../screens/home/bloc/home_event.dart';
import '../screens/home/home_screen.dart';
import '../screens/settings/bloc/settings_bloc.dart';
import '../screens/settings/bloc/settings_event.dart';
import '../screens/settings/settings_screen.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => HomeBloc(
            transactions: context.read<TransactionRepository>(),
            settings: context.read<SettingsRepository>(),
          )..add(const HomeStarted()),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(
          create: (context) => HistoryBloc(
            transactions: context.read<TransactionRepository>(),
            deleteTransaction: context.read<DeleteTransaction>(),
          )..add(const HistoryStarted()),
          child: const HistoryScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => BlocProvider(
          create: (context) => SettingsBloc(
            settings: context.read<SettingsRepository>(),
          )..add(const SettingsStarted()),
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => BlocProvider(
          create: (context) => CategoriesBloc(
            categories: context.read<CategoryRepository>(),
          )..add(const CategoriesStarted()),
          child: const CategoriesScreen(),
        ),
      ),
      GoRoute(
        path: '/categories/new',
        builder: (context, state) {
          final typeName = state.uri.queryParameters['type'];
          final type = typeName == TransactionType.income.name
              ? TransactionType.income
              : TransactionType.expense;
          return BlocProvider(
            create: (context) => _categoryFormBloc(context, type: type)
              ..add(const CategoryFormStarted()),
            child: CategoryFormScreen(type: type),
          );
        },
      ),
      GoRoute(
        path: '/categories/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (context) => _categoryFormBloc(context, categoryId: id)
              ..add(const CategoryFormStarted()),
            child: CategoryFormScreen(categoryId: id),
          );
        },
      ),
      GoRoute(
        path: '/transaction/new',
        builder: (context, state) => BlocProvider(
          create: (context) => _addTransactionBloc(context)
            ..add(const AddTransactionStarted()),
          child: const AddTransactionScreen(),
        ),
      ),
      GoRoute(
        path: '/transaction/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (context) => _addTransactionBloc(context, transactionId: id)
              ..add(const AddTransactionStarted()),
            child: AddTransactionScreen(transactionId: id),
          );
        },
      ),
    ],
  );
}

AddTransactionBloc _addTransactionBloc(
  BuildContext context, {
  int? transactionId,
}) {
  return AddTransactionBloc(
    transactions: context.read<TransactionRepository>(),
    categories: context.read<CategoryRepository>(),
    settings: context.read<SettingsRepository>(),
    createTransaction: context.read<CreateTransaction>(),
    updateTransaction: context.read<UpdateTransaction>(),
    transactionId: transactionId,
  );
}

CategoryFormBloc _categoryFormBloc(
  BuildContext context, {
  int? categoryId,
  TransactionType type = TransactionType.expense,
}) {
  return CategoryFormBloc(
    categories: context.read<CategoryRepository>(),
    transactions: context.read<TransactionRepository>(),
    createCategory: context.read<CreateCategory>(),
    updateCategory: context.read<UpdateCategory>(),
    deleteCategory: context.read<DeleteCategory>(),
    categoryId: categoryId,
    type: type,
  );
}
