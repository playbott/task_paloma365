import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_paloma365/bloc/bloc_providers.dart';
import 'package:task_paloma365/bloc/cart_bloc.dart';
import 'package:task_paloma365/bloc/order_bloc.dart';
import 'package:task_paloma365/bloc/product_bloc.dart';
import 'package:task_paloma365/global.dart';
import 'package:task_paloma365/screens/components/product_card.dart';
import 'components/cart_product_tile.dart';
import 'components/header_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    super.key,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Продукты'),
        actions: [
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove(currentOrderIdStorageKey);
              cartBloc.add(CartEventGet());
              orderBloc.add(OrderEventGet());
            },
            icon: Icon(
              Icons.check,
              size: 28,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 28,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BlocBuilder<OrderBloc, OrderState>(
                  bloc: orderBloc..add(OrderEventGet()),
                  builder: (context, state) {
                    if (state is OrderStateCompleted) {
                      if (state.currentOrderId != null &&
                          state.orders.isNotEmpty) {
                        final order = state.orders
                            .where((e) => e['id'] == state.currentOrderId)
                            .firstOrNull;
                        if (order != null) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '№' +
                                      order['id'].toString().padLeft(2, '0') +
                                      '  ' +
                                      dateFormatHHmm(
                                          DateTime.parse(order['created_at'])),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  '💸 ₽' +
                                      order['price_summary'].toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  order['place'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }
                    return SizedBox.shrink();
                  }),
            ),
          ),
          AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 200),
            child: BlocBuilder<CartBloc, CartState>(
                bloc: cartBloc..add(CartEventGet()),
                builder: (context, state) {
                  if (state is CartStateCompleted) {
                    final cartProducts = state.carts;
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: Container(
                        decoration: cartProducts.isNotEmpty
                            ? BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black26,
                                  ),
                                ),
                              )
                            : null,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                cartProducts.length,
                                (i) {
                                  final product = cartProducts[i];
                                  return CartProduct(
                                    cartProductId: product['cart_id'],
                                    title: product['name'],
                                    count: product['count'],
                                    price: product['price'],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              bloc: productBloc..add(ProductEventGet()),
              builder: (context, state) {
                if (state is ProductStateLoading) {
                  return const Center(
                      child: SizedBox.square(
                          dimension: 50, child: CircularProgressIndicator()));
                }

                if (state is ProductStateCompleted) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    scrollDirection: Axis.vertical,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) {
                        var products = List.from(state.products);
                        products.shuffle(Random.secure());
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              HeaderCard(title: '${index + 1} блюда'),
                              const SizedBox(
                                height: 20,
                              ),
                              ...List.generate(
                                products.length,
                                (i) {
                                  final product = products[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        cartBloc.add(
                                            CartEventAddToCart(product['id']));
                                      },
                                      child: ProductCard(
                                        title: product['name'],
                                        price: product['price'],
                                        imagePath: product['image_path'],
                                        inStock: product['in_stock_count'],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
