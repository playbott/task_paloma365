import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_paloma365/bloc/order_bloc.dart';
import 'package:task_paloma365/global.dart';
import 'package:task_paloma365/service/queries.dart';
import 'package:task_paloma365/service/sqlite.dart';

import 'bloc_providers.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartStateNotInitialized()) {
    on<CartEvent>(
      (event, emit) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? currentOrderId = prefs.getInt(currentOrderIdStorageKey);
        final Database db = await LocalDb.open();
        if (event is CartEventGet) {
          if (currentOrderId != null) {
            List<Map<String, dynamic>> carts = await getCartProducts(db, currentOrderId);
            emit(CartStateCompleted(carts));
          } else {
            emit(CartStateCompleted([]));
          }
        }

        if (event is CartEventUpdateCount) {
          await updateCartProductCount(
            db,
            cartProductId: event.cartProductId,
            count: event.count,
          );
          orderBloc..add(OrderEventGet());

          add(CartEventGet());
        }

        if (event is CartEventAddToCart) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final currentOrderId = prefs.getInt(currentOrderIdStorageKey);
          if (currentOrderId != null) {
            await insertCartProduct(
              db,
              productId: event.productId,
              orderId: currentOrderId,
            );
            orderBloc..add(OrderEventGet());
            add(CartEventGet());
          }
        }
      },
    );
  }
}

final class CartEventUpdateCount extends CartEvent {
  CartEventUpdateCount(this.cartProductId, this.count);

  final int cartProductId;
  final int count;
}

final class CartEventAddToCart extends CartEvent {
  CartEventAddToCart(this.productId);

  final int productId;
}

final class CartEventGet extends CartEvent {}

final class CartEventCreate extends CartEvent {
  CartEventCreate(this.place);

  final String place;
}

class CartStateNotInitialized extends CartState {}

class CartStateCompleted extends CartState {
  List<Map<String, dynamic>> carts;

  CartStateCompleted(this.carts);
}

class CartState {}

class CartEvent {}
