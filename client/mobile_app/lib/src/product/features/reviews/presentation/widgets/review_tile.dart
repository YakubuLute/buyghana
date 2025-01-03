import 'package:ecomly/core/common/widgets/expandable_text.dart';
import 'package:ecomly/core/common/widgets/rating_stars.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile.preview(
    this.review, {
    super.key,
    this.margin,
  }) : previewMode = true;

  const ReviewTile(
    this.review, {
    super.key,
    this.margin,
  }) : previewMode = false;

  final Review review;
  final bool previewMode;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMMM dd, yyyy').format(review.date);
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!previewMode) ...[
            Text(
              review.userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.headingMedium3.adaptiveColour(context),
            ),
            const Gap(8),
          ],
          RatingStars(review.rating),
          if (review.comment.trim().isNotEmpty) ...[
            const Gap(8),
            ExpandableText(
              context,
              text: review.comment.trim(),
              style: TextStyles.paragraphRegular.grey,
            ),
          ],
          const Gap(8),
          if (!previewMode)
            Text(
              date,
              style: TextStyles.paragraphSubTextRegular2.grey,
            )
          else
            RichText(
              text: TextSpan(
                text: '${review.userName}: ',
                style:
                    TextStyles.paragraphSubTextRegular2.adaptiveColour(context),
                children: [
                  TextSpan(
                    text: date,
                    style: const TextStyle(
                      color: Colours.lightThemeSecondaryTextColour,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
