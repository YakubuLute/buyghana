import 'package:ecomly/core/extensions/date_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_stack/image_stack.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.order, {required this.controller, super.key});

  final Order order;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/orders/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: Colours.lightThemeWhiteColour,
            darkModeColour: Colours.darkThemeDarkSharpColour,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(builder: (context) {
              final images =
                  order.orderItems.map((item) => item.productImage).toList();
              return ImageStack(
                imageList: images,
                totalCount: images.length,
                // If larger than images.length, will show extra empty circle
                imageRadius: 50,
                imageCount: 3,
                imageBorderWidth: 3,
              );
            }),
            const Gap(10),
            SelectableText.rich(
              TextSpan(
                text: 'Order Number: ',
                style: TextStyles.headingMedium4.adaptiveColour(context),
                children: [
                  TextSpan(
                    text: order.id,
                    style: TextStyles.paragraphSubTextRegular3.grey,
                  ),
                ],
              ),
            ),
            const Gap(10),
            Text.rich(
              TextSpan(
                text: 'Sub Total: ',
                style: TextStyles.headingMedium4.adaptiveColour(context),
                children: [
                  TextSpan(
                    text: '\$${order.totalPrice.toStringAsFixed(2)}',
                    style: TextStyles.paragraphSubTextRegular3.grey,
                  ),
                ],
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.status.category == 'completed' ||
                    order.status.category == 'cancelled')
                  Text(
                    '⚫ ${order.status.displayName}',
                    style: TextStyles.paragraphSubTextRegular3.copyWith(
                      color: order.status.colour,
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 10, color: order.status.colour)
                          .animate(
                            controller: controller,
                            onComplete: (controller) => controller.loop(),
                          )
                          .fadeIn()
                          .then()
                          .fadeOut(),
                      const Gap(3),
                      Text(
                        order.status.displayName,
                        style: TextStyles.paragraphSubTextRegular3.grey,
                      ),
                    ],
                  ),
                Text(
                  order.dateOrdered.format,
                  style: TextStyles.paragraphSubTextRegular3.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
