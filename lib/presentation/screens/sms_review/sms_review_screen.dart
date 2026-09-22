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
import '../../widgets/dialogs.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_primary_button.dart';
import 'bloc/sms_review_bloc.dart';
import 'bloc/sms_review_event.dart';
import 'bloc/sms_review_state.dart';

class SmsReviewScreen extends StatefulWidget {
  const SmsReviewScreen({super.key, required this.inboxId});

  final int inboxId;

  @override
  State<SmsReviewScreen> createState() => _SmsReviewScreenState();
}

class _SmsReviewScreenState extends State<SmsReviewScreen> {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return BlocConsumer<SmsReviewBloc, SmsReviewState>(
      listenWhen: (previous, current) {
        if (!_hydrated && !current.loading) return true;
        if (current.saved && !previous.saved) return true;
        if (current.dismissed && !previous.dismissed) return true;
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
        if (state.saved || state.dismissed) {
          context.pop();
          return;
        }
        if (state.errorMessage != null) {
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
        final bloc = context.read<SmsReviewBloc>();
        final symbol = currencyByCode(state.currencyCode).symbol;

        return Scaffold(
          appBar: LedgrAppBar(
            title: l10n.confirmEntry,
            leading: IconButton(
              tooltip: l10n.close,
              onPressed: () => context.pop(),
              icon: Icon(TablerIcons.x, color: colors.onSurface, size: 19.r),
            ),
            actions: [
              IconButton(
                key: const Key('sms-dismiss'),
                tooltip: l10n.skip,
                onPressed: () async {
                  final confirmed = await showDeleteConfirmDialog(
                    context: context,
                    title: l10n.skipSmsTitle,
                    message: l10n.skipSmsMessage,
                    confirmLabel: l10n.skip,
                  );
                  if (confirmed && context.mounted) {
                    bloc.add(const SmsReviewDismissRequested());
                  }
                },
                icon: Icon(TablerIcons.trash,
                    color: colors.ledgerRed, size: 19.r),
              ),
            ],
          ),
          body: state.loading
              ? Center(child: CircularProgressIndicator(color: colors.primary))
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
                              SmsReviewTypeChanged(
                                expense
                                    ? TransactionType.expense
                                    : TransactionType.income,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
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
                                  onChanged: (value) =>
                                      bloc.add(SmsReviewAmountChanged(value)),
                                ),
                              ),
                            ],
                          ),
                          if (state.currencyMismatch)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                l10n.smsCurrencyMismatch(
                                  state.smsCurrencyCode ?? '',
                                ),
                                textAlign: TextAlign.center,
                                style: uiStyle(
                                  fontSize: 12,
                                  color: colors.secondary,
                                ),
                              ),
                            ),
                          SizedBox(height: 20.h),
                          if (state.categoriesLoading)
                            Center(
                              child: CircularProgressIndicator(
                                color: colors.primary,
                              ),
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
                                  itemCount: state.categories.length + 1,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 12.h,
                                    crossAxisSpacing: 8.w,
                                    childAspectRatio: 0.72,
                                  ),
                                  itemBuilder: (context, index) {
                                    if (index == state.categories.length) {
                                      return CategoryCircle(
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
                                              SmsReviewCategorySelected(
                                                createdId,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                    final category = state.categories[index];
                                    return CategoryCircle(
                                      key: Key('category-${category.name}'),
                                      icon: tablerIcon(category.iconCodePoint),
                                      label: localizedCategoryName(
                                        l10n,
                                        category.name,
                                      ),
                                      size: 44.r,
                                      selected: state.categoryId == category.id,
                                      iconColor: Color(category.colorValue),
                                      onTap: () => bloc.add(
                                        SmsReviewCategorySelected(category.id),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(height: 16.h),
                          TextField(
                            controller: _note,
                            style:
                                uiStyle(fontSize: 14, color: colors.onSurface),
                            cursorColor: colors.primary,
                            decoration: InputDecoration(
                              hintText: l10n.noteOptional,
                              hintStyle: uiStyle(
                                  fontSize: 14, color: colors.secondary),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) =>
                                bloc.add(SmsReviewNoteChanged(value)),
                          ),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return DatePickerTheme(
                                    data: ledgrDatePickerTheme(colors),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                bloc.add(SmsReviewDateChanged(picked));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Row(
                                children: [
                                  Icon(
                                    TablerIcons.calendar,
                                    size: 18.r,
                                    color: colors.secondary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    formatLedgerDate(state.date, l10n: l10n),
                                    style: uiStyle(
                                      fontSize: 13,
                                      color: colors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.body,
                            style:
                                uiStyle(fontSize: 12, color: colors.secondary),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                        child: Column(
                          children: [
                            if (state.missingRequiredFields)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Text(
                                  l10n.missingAmountAndCategory,
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
                                  ? () =>
                                      bloc.add(const SmsReviewSaveRequested())
                                  : null,
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
