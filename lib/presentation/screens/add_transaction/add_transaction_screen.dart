import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../theme/typography.dart';
import '../../formatters/currencies.dart';
import '../../formatters/date_labels.dart';
import '../../formatters/money_input_formatter.dart';
import '../../icons/tabler_icon.dart';
import '../../widgets/category_circle.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_primary_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final id = widget.transactionId;

    return BlocConsumer<AddTransactionBloc, AddTransactionState>(
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
        if (state.saved) {
          context.pop();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<AddTransactionBloc>();
        final symbol = currencyByCode(state.currencyCode).symbol;

        return Scaffold(
          appBar: LedgrAppBar(
            title: id == null ? 'New entry' : 'Edit entry',
            leading: IconButton(
              tooltip: 'Close',
              onPressed: () => context.pop(),
              icon: const Icon(TablerIcons.x, color: paper, size: 19),
            ),
          ),
          body: state.loading
              ? const Center(
                  child: CircularProgressIndicator(color: tealAccent),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        children: [
                          DebitCreditToggle(
                            expenseSelected:
                                state.type == TransactionType.expense,
                            onChanged: (expense) => bloc.add(
                              AddTransactionTypeChanged(
                                expense
                                    ? TransactionType.expense
                                    : TransactionType.income,
                              ),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(symbol, style: amountStyle(fontSize: 40)),
                              const SizedBox(width: 8),
                              IntrinsicWidth(
                                child: TextField(
                                  key: const Key('amount-field'),
                                  controller: _amount,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatters: const [MoneyInputFormatter()],
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  style: amountStyle(fontSize: 40),
                                  cursorColor: tealAccent,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '0.00',
                                    hintStyle: amountStyle(
                                      fontSize: 40,
                                      color: mutedInk,
                                    ),
                                  ),
                                  onChanged: (value) => bloc.add(
                                    AddTransactionAmountChanged(value),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          if (state.categoriesLoading)
                            const Center(
                              child:
                                  CircularProgressIndicator(color: tealAccent),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.categories.length + 1,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.85,
                              ),
                              itemBuilder: (context, index) {
                                if (index == state.categories.length) {
                                  return CategoryCircle(
                                    key: const Key('add-new-category'),
                                    icon: TablerIcons.plus,
                                    label: 'Add new',
                                    onTap: () async {
                                      final createdId = await context.push<int>(
                                        '/categories/new?type=${state.type.name}',
                                      );
                                      if (createdId != null && context.mounted) {
                                        bloc.add(
                                          AddTransactionCategorySelected(
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
                                  label: category.name,
                                  selected: state.categoryId == category.id,
                                  onTap: () => bloc.add(
                                    AddTransactionCategorySelected(category.id),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _note,
                            style: uiStyle(fontSize: 14),
                            cursorColor: tealAccent,
                            decoration: InputDecoration(
                              hintText: 'Note (optional)',
                              hintStyle: uiStyle(fontSize: 14, color: mutedInk),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) =>
                                bloc.add(AddTransactionNoteChanged(value)),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: ruleColor)),
                            ),
                            padding: const EdgeInsets.only(top: 14),
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: state.date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return DatePickerTheme(
                                      data: ledgrDatePickerTheme,
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  bloc.add(AddTransactionDateChanged(picked));
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    TablerIcons.calendar,
                                    size: 18,
                                    color: mutedInk,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    formatLedgerDate(state.date),
                                    style:
                                        uiStyle(fontSize: 13, color: mutedInk),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        child: Column(
                          children: [
                            if (state.missingRequiredFields)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Enter an amount and choose a category',
                                  style: uiStyle(fontSize: 12, color: mutedInk),
                                ),
                              ),
                            LedgrPrimaryButton(
                              key: const Key('save-entry'),
                              label: 'Save entry',
                              onPressed: state.canSave
                                  ? () => bloc.add(
                                        const AddTransactionSaveRequested(),
                                      )
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
