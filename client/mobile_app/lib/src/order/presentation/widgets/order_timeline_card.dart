import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/core/utils/enums/order_status_enum.dart';
import 'package:ecomly/src/order/presentation/order_utils.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class OrderTimelineCard extends StatelessWidget {
  const OrderTimelineCard({
    required this.statusHistory,
    required this.currentStatus,
    super.key,
  });

  final List<OrderStatus> statusHistory;
  final OrderStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final isCancelled = currentStatus.category == 'cancelled';
    final isCompleted = currentStatus.category == 'completed';
    var timeline = <OrderStatus>[];
    if (isCancelled || isCompleted) {
      timeline = List.from(statusHistory);
      if (!timeline.contains(currentStatus)) timeline.add(currentStatus);
    } else {
      final progression = [
        OrderStatus.pending,
        OrderStatus.processed,
        OrderStatus.shipped,
        OrderStatus.outForDelivery,
        OrderStatus.delivered,
      ];
      timeline = List.from(statusHistory);
      for (final status in progression) {
        if (!timeline.contains(status)) timeline.add(status);
      }
    }
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: CoreUtils.adaptiveColour(
          context,
          lightModeColour: Colours.lightThemeWhiteColour,
          darkModeColour: Colours.darkThemeDarkNavBarColour,
        ),
      ),
      child: TimelineTheme(
        data: TimelineThemeData(
          color: Colours.lightThemePrimaryColour,
        ),
        child: Timeline.tileBuilder(
          builder: TimelineTileBuilder.connected(
            indicatorBuilder: (context, index) {
              final status = timeline[index];
              final done =
                  statusHistory.contains(status) || status == currentStatus;
              final doneColour = OrderUtils.getSpecialTimelineColour(status);
              return DotIndicator(
                color:
                    done ? doneColour : Colours.lightThemeSecondaryTextColour,
                child: doneColour == null || currentStatus.category == 'active'
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          status.category == 'completed'
                              ? Icons.check
                              : Icons.close,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
              );
            },
            connectorBuilder: (_, index, connectorType) {
              final status = timeline[index];
              return SolidLineConnector(
                indent: connectorType == ConnectorType.start ? 5.0 : 5.0,
                endIndent: connectorType == ConnectorType.end ? 5.0 : 5.0,
                thickness: 1,
                color: statusHistory.contains(status) || status == currentStatus
                    ? null
                    : Colours.lightThemeSecondaryTextColour,
              );
            },
            indicatorPositionBuilder: (context, index) => .5,
            contentsBuilder: (_, index) {
              final status = timeline[index];
              final done =
                  statusHistory.contains(status) || status == currentStatus;
              return Card(
                margin: const EdgeInsets.only(left: 20),
                color: done
                    ? OrderUtils.getSpecialTimelineColour(
                        status,
                        defaultColour: Colours.lightThemePrimaryColour,
                      )
                    : Colours.lightThemeSecondaryTextColour,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    status.displayName,
                    style: const TextStyle(
                      color: Colours.lightThemeWhiteColour,
                    ),
                  ),
                ),
              );
            },
            itemExtentBuilder: (_, index) {
              return 110;
            },
            itemCount: timeline.length,
          ),
        ),
      ),
    );
  }
}
