import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_paloma365/bloc/bloc_providers.dart';
import 'package:task_paloma365/bloc/order_bloc.dart';

import 'components/order_tile.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Заказы'),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
          bloc: orderBloc,
          builder: (context, state) {
            if (state is OrderStateLoading) {
              return Center(
                  child: SizedBox.square(
                      dimension: 50, child: CircularProgressIndicator()));
            }
            if (state is OrderStateCompleted) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.orders.length,
                    (index) {
                      final order = state.orders[index];
                      return OrderTile(
                        id: order['id'],
                        createdAt: order['created_at'],
                        priceSummary: order['price_summary'],
                        place: order['place'],
                      );
                    },
                  ),
                ),
              );
            }
            return Text(
              'Ничего нет',
              style: TextStyle(fontSize: 20, color: Colors.black26),
            );
          }),
    );
  }
}
