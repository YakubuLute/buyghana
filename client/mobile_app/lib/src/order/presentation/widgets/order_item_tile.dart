import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/order/domain/entities/order_item.dart';
import 'package:ecomly/src/product/presentation/widgets/colour_palette.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile(this.orderItem, {super.key});

  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/products/${orderItem.productId}'),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xfff0f0f0),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(orderItem.productImage),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderItem.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyles.headingMedium4.adaptiveColour(context),
                      ),
                      const Gap(5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${orderItem.productPrice.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium4.orange,
                          ),
                          if (orderItem.selectedColour != null) ...[
                            const Gap(5),
                            Flexible(
                              child: ColourPalette(
                                colours: [orderItem.selectedColour!],
                                radius: 5,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (orderItem.selectedSize != null)
                        Text(
                          'Size: ${orderItem.selectedSize}',
                          style: TextStyles.paragraphSubTextRegular1
                              .adaptiveColour(context),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              'QUANTITY: ${orderItem.quantity}',
              style:
                  TextStyles.paragraphSubTextRegular1.adaptiveColour(context),
            ),
          ],
        ),
      ),
    );
  }
}
