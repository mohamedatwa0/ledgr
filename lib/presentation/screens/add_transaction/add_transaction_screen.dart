import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../theme/typography.dart';
import '../../formatters/category_labels.dart';
import '../../formatters/currencies.dart';
import '../../formatters/date_labels.dart';
import '../../formatters/error_labels.dart';
import '../../formatters/money_input_formatter.dart';
import '../../icons/tabler_icon.dart';
import '../../router/app_router.dart';
import '../../widgets/category_circle.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/directional_icon.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_primary_button.dart';
import '../../widgets/numeric_keypad.dart';
import 'bloc/add_transaction_bloc.dart';
import 'bloc/add_transaction_event.dart';
import 'bloc/add_transaction_state.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.transactionId});

  final int? transactionId;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final TextEditingController _amount;
  late final TextEditingController _note;
  var _hydrated = false;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController();
    _note = TextEditingController();
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _setAmount(String value) {
    _amount.text = value;
    _amount.selection = TextSelection.collapsed(offset: value.length);
    context.read<AddTransactionBloc>().add(AddTransactionAmountChanged(value));
  }

  Future<void> _onBack(
    BuildContext context,
    AddTransactionState state,
    bool isNew,
  ) async {
    if (isNew && state.isDirty) {
      final l10n = context.l10n;
      final discard = await showDeleteConfirmDialog(
        context: context,
        title: l10n.discardEntryTitle,
        message: l10n.discardEntryMessage,
        confirmLabel: l10n.discard,
      );
      if (discard && context.mounted) context.pop();
      return;
    }
    context.pop();
  }

  Future<void> _onDelete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDeleteConfirmDialog(
      context: context,
      title: l10n.deleteEntry,
      message: l10n.deleteEntryMessage,
    );
    if (confirmed && context.mounted) {
      context
          .read<AddTransactionBloc>()
          .add(const AddTransactionDeleteRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.transactionId;
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocConsumer<AddTransactionBloc, AddTransactionState>(
      listenWhen: (previous, current) {
        if (!_hydrated && !current.loading) return true;
        if (current.saved && !previous.saved) return true;
        if (current.deleted && !previous.deleted) return true;
        if (current.errorMessage != null &&
            current.errorMessage != previous.errorMessage) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (!_hydrated && !state.loading) {
          _hydrated = true;
          if (state.amountText.isNotEmpty && _amount.text.isEmpty) {
            _amount.text = state.amountText;
          }
          if (state.note.isNotEmpty && _note.text.isEmpty) {
            _note.text = state.note;
          }
        }
        if (state.saved || state.deleted) {
          context.pop();
          return;
        }
        if (state.errorMessage != null && !state.notFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizedLedgrErrorMessage(l10n, state.errorMessage!),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<AddTransactionBloc>();
        final symbol = currencyByCode(state.currencyCode).symbol;

        return Scaffold(
          appBar: LedgrAppBar(
            title: id == null ? l10n.newEntry : l10n.editEntry,
            leading: IconButton(
              tooltip: l10n.back,
              onPressed: () => _onBack(context, state, id == null),
              icon: DirectionalIcon(
                TablerIcons.arrow_left,
                color: colors.onSurface,
                size: 22.r,
              ),
            ),
            actions: [
              if (id != null && !state.notFound)
                IconButton(
                  key: const Key('delete-entry'),
                  tooltip: l10n.deleteEntry,
                  onPressed: () => _onDelete(context),
                  icon: Icon(
                    TablerIcons.trash,
                    color: colors.ledgerRed,
                    size: 19.r,
                  ),
                ),
            ],
          ),
          body: state.loading
              ? Center(child: CircularProgressIndicator(color: colors.primary))
              : state.notFound
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          l10n.transactionNotFound,
                          textAlign: TextAlign.center,
                          style: uiStyle(
                            fontSize: 14,
                            color: colors.secondary,
                          ),
                        ),
                      ),
                    )
                  : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                        children: [
                          DebitCreditToggle(
                            expenseSelected:
                                state.type == TransactionType.expense,
                            expanded: true,
                            onChanged: (expense) => bloc.add(
                              AddTransactionTypeChanged(
                                expense
                                    ? TransactionType.expense
                                    : TransactionType.income,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            l10n.entryValue,
                            textAlign: TextAlign.center,
                            style: uiStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: colors.secondary,
                              letterSpacing: ltrLetterSpacing(context, 1.6),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                symbol,
                                style: amountStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: colors.secondary,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              IntrinsicWidth(
                                child: TextField(
                                  key: const Key('amount-field'),
                                  controller: _amount,
                                  keyboardType: TextInputType.none,
                                  inputFormatters: const [
                                    MoneyInputFormatter()
                                  ],
                                  textAlign: TextAlign.center,
                                  style: amountStyle(
                                    fontSize: 28,
                                    color: colors.onSurface,
                                  ),
                                  cursorColor: colors.primary,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '0.00',
                                    hintStyle: amountStyle(
                                      fontSize: 28,
                                      color: colors.secondary,
                                    ),
                                  ),
                                  onChanged: (value) => bloc
                                      .add(AddTransactionAmountChanged(value)),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              width: 128.w,
                              height: 2.h,
                              margin: EdgeInsets.only(top: 8.h),
                              color: state.type == TransactionType.expense
                                  ? colors.ledgerRed
                                  : colors.ledgerGreen,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6.w,
                            children: [
                              for (final chip in const [5, 10, 25, 50])
                                ActionChip(
                                  label: Text('+$chip'),
                                  onPressed: () => _setAmount(
                                      addQuickAmount(_amount.text, chip)),
                                  backgroundColor: colors.surfaceContainer,
                                  labelStyle: uiStyle(
                                    fontSize: 12,
                                    color: colors.secondary,
                                  ),
                                  side: BorderSide.none,
                                ),
                              ActionChip(
                                label: Icon(
                                  TablerIcons.backspace,
                                  size: 14.r,
                                  color: colors.ledgerRed,
                                ),
                                onPressed: () =>
                                    _setAmount(backspaceAmount(_amount.text)),
                                backgroundColor: colors.surfaceContainerHigh,
                                side: BorderSide.none,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Text(
                                l10n.ledgerAccount,
                                style: uiStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colors.secondary,
                                  letterSpacing: ltrLetterSpacing(context, 1.0),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                l10n.categoriesCount(state.categories.length),
                                style: uiStyle(
                                    fontSize: 10, color: colors.secondary),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          if (state.categoriesLoading)
                            Center(
                              child: CircularProgressIndicator(
                                  color: colors.primary),
                            )
                          else
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.categories.length +
                                      (state.hasPendingCategory ? 1 : 0) +
                                      1,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 12.h,
                                    crossAxisSpacing: 8.w,
                                    childAspectRatio: 0.72,
                                  ),
                                  itemBuilder: (context, index) {
                                    if (index < state.categories.length) {
                                      final category = state.categories[index];
                                      return CategoryCircle(
                                        key: Key('category-${category.name}'),
                                        icon:
                                            tablerIcon(category.iconCodePoint),
                                        label: localizedCategoryName(
                                            l10n, category.name),
                                        size: 44.r,
                                        selected:
                                            state.categoryId == category.id,
                                        iconColor: Color(category.colorValue),
                                        onTap: () => bloc.add(
                                          AddTransactionCategorySelected(
                                              category.id),
                                        ),
                                      );
                                    }
                                    if (state.hasPendingCategory &&
                                        index == state.categories.length) {
                                      return CategoryCircle(
                                        key: Key(
                                          'pending-category-${state.pendingCategoryName}',
                                        ),
                                        icon: TablerIcons.tag,
                                        label: state.pendingCategoryName!,
                                        size: 44.r,
                                        selected: state.categoryId == null,
                                        onTap: () => bloc.add(
                                          const AddTransactionPendingCategorySelected(),
                                        ),
                                      );
                                    }
                                    return CategoryCircle(
                                      key: const Key('add-new-category'),
                                      icon: TablerIcons.plus,
                                      label: l10n.addNew,
                                      size: 44.r,
                                      onTap: () async {
                                        final createdId =
                                            await showCategoryFormSheet(
                                          context,
                                          type: state.type,
                                        );
                                        if (createdId != null &&
                                            context.mounted) {
                                          bloc.add(
                                            AddTransactionCategorySelected(
                                                createdId),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(height: 16.h),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.paperLight,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: 4.w,
                                    decoration: BoxDecoration(
                                      color:
                                          state.type == TransactionType.expense
                                              ? colors.ledgerRed
                                              : colors.ledgerGreen,
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        topStart: Radius.circular(8.r),
                                        bottomStart: Radius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          12.w, 12.h, 12.w, 12.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                TablerIcons.notes,
                                                size: 20.r,
                                                color: colors.secondary,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: TextField(
                                                  controller: _note,
                                                  style: uiStyle(
                                                    fontSize: 14,
                                                    color: colors.onSurface,
                                                  ),
                                                  cursorColor: colors.primary,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        l10n.bookkeeperMemo,
                                                    labelStyle: uiStyle(
                                                      fontSize: 10,
                                                      color: colors.secondary,
                                                      letterSpacing:
                                                          ltrLetterSpacing(
                                                              context, 0.8),
                                                    ),
                                                    hintText: l10n.noteHint,
                                                    hintStyle: uiStyle(
                                                      fontSize: 14,
                                                      color: colors.secondary
                                                          .withValues(
                                                              alpha: 0.6),
                                                    ),
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                  ),
                                                  onChanged: (value) =>
                                                      bloc.add(
                                                    AddTransactionNoteChanged(
                                                        value),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                              color: colors.rule, height: 16.h),
                                          InkWell(
                                            onTap: () async {
                                              final picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: state.date,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                builder: (context, child) {
                                                  return DatePickerTheme(
                                                    data: ledgrDatePickerTheme(
                                                        colors),
                                                    child: child!,
                                                  );
                                                },
                                              );
                                              if (picked != null) {
                                                bloc.add(
                                                  AddTransactionDateChanged(
                                                      picked),
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  TablerIcons.calendar,
                                                  size: 20.r,
                                                  color: colors.secondary,
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        l10n.transactionDate,
                                                        style: uiStyle(
                                                          fontSize: 10,
                                                          color:
                                                              colors.secondary,
                                                          letterSpacing:
                                                              ltrLetterSpacing(
                                                            context,
                                                            0.8,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        formatLedgerDate(
                                                          state.date,
                                                          l10n: l10n,
                                                        ),
                                                        style: uiStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              colors.onSurface,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  l10n.change,
                                                  style: uiStyle(
                                                    fontSize: 10,
                                                    color: colors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
                      child: NumericKeypad(
                        onDigit: (digit) => _setAmount(
                          appendAmountDigit(_amount.text, digit),
                        ),
                        onBackspace: () =>
                            _setAmount(backspaceAmount(_amount.text)),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                        child: Column(
                          children: [
                            if (state.missingRequiredFields)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Text(
                                  l10n.missingAmountAndCategory,
                                  textAlign: TextAlign.center,
                                  style: uiStyle(
                                    fontSize: 12,
                                    color: colors.secondary,
                                  ),
                                ),
                              ),
                            LedgrPrimaryButton(
                              key: const Key('save-entry'),
                              label: l10n.saveEntry,
                              onPressed: state.canSave
                                  ? () => bloc.add(
                                        const AddTransactionSaveRequested(),
                                      )
                                  : null,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              l10n.offlineEntryNote,
                              style: uiStyle(
                                fontSize: 12,
                                color: colors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
