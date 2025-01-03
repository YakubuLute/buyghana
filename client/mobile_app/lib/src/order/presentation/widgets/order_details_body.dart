import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:ecomly/src/order/presentation/widgets/order_item_tile.dart';
import 'package:ecomly/src/order/presentation/widgets/order_timeline_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OrderDetailsBody extends StatelessWidget {
  const OrderDetailsBody(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText.rich(
            TextSpan(
              text: 'Order ',
              style: TextStyles.headingMedium4.adaptiveColour(context),
              children: [
                TextSpan(
                  text: '#${order.id}',
                  style: TextStyles.paragraphSubTextRegular3.grey,
                ),
              ],
            ),
          ),
          const Gap(5),
          Text.rich(
            TextSpan(
              text: 'No of items: ',
              style: TextStyles.headingMedium4.adaptiveColour(context),
              children: [
                TextSpan(
                  text: order.orderItems.length.toString(),
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
              ],
            ),
          ),
          const Gap(5),
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
          const Gap(5),
          Text.rich(
            TextSpan(
              text: 'Date Ordered: ',
              style: TextStyles.headingMedium4.adaptiveColour(context),
              children: [
                TextSpan(
                  text: DateFormat('dd/MM/yyyy').format(order.dateOrdered),
                  style: TextStyles.paragraphSubTextRegular3.grey,
                ),
              ],
            ),
          ),
          const Gap(5),
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
                    .animate(onComplete: (controller) => controller.loop())
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
          const Gap(10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) {
                final orderItem = order.orderItems[index];
                return OrderItemTile(orderItem);
              },
              separatorBuilder: (_, __) => const Gap(15),
              itemCount: order.orderItems.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  showDragHandle: true,
                  // isDismissible: false,
                  builder: (_) {
                    return OrderTimelineCard(
                      statusHistory: order.statusHistory,
                      currentStatus: order.status,
                    );
                  },
                );
              },
              child: const Text('SEE STATUS HISTORY'),
            ),
          ),
        ],
      ),
    );
  }
}
