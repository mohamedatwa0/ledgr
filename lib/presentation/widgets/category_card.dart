import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/models/category.dart';
import '../../domain/models/transaction_type.dart';
import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../formatters/category_labels.dart';
import '../icons/tabler_icon.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final kind =
        category.type == TransactionType.expense ? l10n.debits : l10n.credits;
    return Material(
      color: colors.paperLight,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          height: 112.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.secondaryContainer,
                      ),
                      child: Icon(
                        tablerIcon(category.iconCodePoint),
                        size: 22.r,
                        color: Color(category.colorValue),
                      ),
                    ),
                    const Spacer(),
                    if (category.isDefault)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          l10n.defaultBadge,
                          style: uiStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: colors.secondary,
                            letterSpacing: ltrLetterSpacing(context, 0.6),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  localizedCategoryName(l10n, category.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: uiStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  kind,
                  style: uiStyle(fontSize: 10, color: colors.secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
