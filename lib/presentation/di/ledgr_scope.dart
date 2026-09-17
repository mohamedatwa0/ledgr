import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/sms_inbox_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/sms/sms_gateway_factory.dart';
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
import '../../domain/usecases/scan_sms_inbox.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/update_transaction.dart';

class LedgrScope extends StatefulWidget {
  const LedgrScope({
    super.key,
    required this.child,
    this.database,
    this.smsGateway,
  });

  final Widget child;
  final AppDatabase? database;
  final SmsGateway? smsGateway;

  @override
  State<LedgrScope> createState() => _LedgrScopeState();
}

class _LedgrScopeState extends State<LedgrScope> {
  late final AppDatabase _db = widget.database ?? AppDatabase();
  late final bool _ownsDb = widget.database == null;
  late final SmsGateway _smsGateway = widget.smsGateway ?? createSmsGateway();

  @override
  void dispose() {
    if (_ownsDb) _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>.value(value: _db),
        RepositoryProvider<SmsGateway>.value(value: _smsGateway),
        RepositoryProvider<TransactionRepository>(
          create: (context) =>
              TransactionRepositoryImpl(context.read<AppDatabase>()),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) =>
              CategoryRepositoryImpl(context.read<AppDatabase>()),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) =>
              SettingsRepositoryImpl(context.read<AppDatabase>()),
        ),
        RepositoryProvider<SmsInboxRepository>(
          create: (context) =>
              SmsInboxRepositoryImpl(context.read<AppDatabase>()),
        ),
        RepositoryProvider<CreateTransaction>(
          create: (context) => CreateTransaction(
            context.read<TransactionRepository>(),
            context.read<CategoryRepository>(),
          ),
        ),
        RepositoryProvider<UpdateTransaction>(
          create: (context) => UpdateTransaction(
            context.read<TransactionRepository>(),
            context.read<CategoryRepository>(),
          ),
        ),
        RepositoryProvider<DeleteTransaction>(
          create: (context) =>
              DeleteTransaction(context.read<TransactionRepository>()),
        ),
        RepositoryProvider<CreateCategory>(
          create: (context) =>
              CreateCategory(context.read<CategoryRepository>()),
        ),
        RepositoryProvider<UpdateCategory>(
          create: (context) =>
              UpdateCategory(context.read<CategoryRepository>()),
        ),
        RepositoryProvider<DeleteCategory>(
          create: (context) =>
              DeleteCategory(context.read<CategoryRepository>()),
        ),
        RepositoryProvider<IngestSms>(
          create: (context) => IngestSms(
            context.read<SmsInboxRepository>(),
            context.read<CategoryRepository>(),
          ),
        ),
        RepositoryProvider<ImportParsedSms>(
          create: (context) => ImportParsedSms(
            context.read<SmsInboxRepository>(),
            context.read<CreateTransaction>(),
          ),
        ),
        RepositoryProvider<DismissSms>(
          create: (context) => DismissSms(context.read<SmsInboxRepository>()),
        ),
        RepositoryProvider<ScanSmsInbox>(
          create: (context) => ScanSmsInbox(
            context.read<SmsGateway>(),
            context.read<SettingsRepository>(),
            context.read<IngestSms>(),
          ),
        ),
      ],
      child: widget.child,
    );
  }
}
