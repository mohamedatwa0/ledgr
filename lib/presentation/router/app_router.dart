import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/sms_inbox_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/sms/sms_gateway.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/create_transaction.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/dismiss_sms.dart';
import '../../domain/usecases/import_parsed_sms.dart';
import '../../domain/usecases/ingest_sms.dart';
import '../../domain/usecases/reset_ledger.dart';
import '../../domain/usecases/scan_sms_inbox.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/voice/parse_voice_entry.dart';
import '../screens/add_transaction/add_transaction_screen.dart';
import '../screens/add_transaction/bloc/add_transaction_bloc.dart';
import '../screens/add_transaction/bloc/add_transaction_event.dart';
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
import '../screens/sms_inbox/bloc/sms_inbox_bloc.dart';
import '../screens/sms_inbox/bloc/sms_inbox_event.dart';
import '../screens/sms_inbox/sms_inbox_screen.dart';
import '../screens/sms_review/bloc/sms_review_bloc.dart';
import '../screens/sms_review/bloc/sms_review_event.dart';
import '../screens/sms_review/sms_review_screen.dart';
import '../widgets/ledgr_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LedgrShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => BlocProvider(
                  create: (context) => HomeBloc(
                    transactions: context.read<TransactionRepository>(),
                    settings: context.read<SettingsRepository>(),
                    deleteTransaction: context.read<DeleteTransaction>(),
                  )..add(const HomeStarted()),
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
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
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => BlocProvider(
                  create: (context) => SettingsBloc(
                    settings: context.read<SettingsRepository>(),
                    smsInbox: context.read<SmsInboxRepository>(),
                    resetLedger: context.read<ResetLedger>(),
                  )..add(const SettingsStarted()),
                  child: const SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/sms',
        builder: (context, state) => BlocProvider(
          create: (context) => SmsInboxBloc(
            inbox: context.read<SmsInboxRepository>(),
            gateway: context.read<SmsGateway>(),
            ingestSms: context.read<IngestSms>(),
            scanSmsInbox: context.read<ScanSmsInbox>(),
            dismissSms: context.read<DismissSms>(),
          )..add(const SmsInboxStarted()),
          child: const SmsInboxScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/sms/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (context) => SmsReviewBloc(
              inboxId: id,
              inbox: context.read<SmsInboxRepository>(),
              categories: context.read<CategoryRepository>(),
              settings: context.read<SettingsRepository>(),
              importParsedSms: context.read<ImportParsedSms>(),
              dismissSms: context.read<DismissSms>(),
            )..add(const SmsReviewStarted()),
            child: SmsReviewScreen(inboxId: id),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/transaction/new',
        builder: (context, state) {
          final extra = state.extra;
          return BlocProvider(
            create: (context) => _addTransactionBloc(
              context,
              voiceDraft: extra is ParsedVoiceEntry ? extra : null,
            )..add(const AddTransactionStarted()),
            child: const AddTransactionScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
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
  ParsedVoiceEntry? voiceDraft,
}) {
  return AddTransactionBloc(
    transactions: context.read<TransactionRepository>(),
    categories: context.read<CategoryRepository>(),
    settings: context.read<SettingsRepository>(),
    createTransaction: context.read<CreateTransaction>(),
    updateTransaction: context.read<UpdateTransaction>(),
    deleteTransaction: context.read<DeleteTransaction>(),
    createCategory: context.read<CreateCategory>(),
    transactionId: transactionId,
    voiceDraft: voiceDraft,
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

Future<int?> showCategoryFormSheet(
  BuildContext context, {
  int? categoryId,
  TransactionType type = TransactionType.expense,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return BlocProvider(
        create: (_) => _categoryFormBloc(
          context,
          categoryId: categoryId,
          type: type,
        )..add(const CategoryFormStarted()),
        child: CategoryFormScreen(
          categoryId: categoryId,
          type: type,
        ),
      );
    },
  );
}
