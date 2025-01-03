import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:ecomly/src/order/presentation/widgets/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrdersBody extends StatefulWidget {
  const OrdersBody(this.orders, {super.key});

  final DataMap orders;

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> with TickerProviderStateMixin {
  late final TabController tabController;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: context.theme.copyWith(
            // As suggested by https://stackoverflow.com/a/75573719/17971158
            colorScheme: context.theme.colorScheme.copyWith(
              surfaceVariant: Colors.transparent,
            ),
          ),
          child: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            isScrollable: false,
            labelColor: Colours.lightThemePrimaryColour,
            labelStyle:
                TextStyles.buttonTextHeadingSemiBold.adaptiveColour(context),
            unselectedLabelColor: Colours.lightThemeSecondaryTextColour,
            tabs: const [
              Tab(
                child: Center(child: Text('Active')),
              ),
              Tab(
                child: Center(child: Text('Completed')),
              ),
              Tab(
                child: Center(child: Text('Cancelled')),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: List.generate(3, (outerMostIndex) => outerMostIndex)
                .map((middleLayerIndex) {
              final orders = switch (middleLayerIndex) {
                0 => widget.orders['active'] as List<Order>,
                1 => widget.orders['completed'] as List<Order>,
                2 => widget.orders['cancelled'] as List<Order>,
                _ => [],
              };
              return ListView.separated(
                itemCount: orders.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                separatorBuilder: (_, __) => const Gap(20),
                itemBuilder: (context, innerMostIndex) {
                  final order = orders[innerMostIndex];
                  return OrderTile(order, controller: animationController);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
