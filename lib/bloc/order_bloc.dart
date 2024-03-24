import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_paloma365/bloc/bloc_providers.dart';
import 'package:task_paloma365/bloc/cart_bloc.dart';
import 'package:task_paloma365/service/queries.dart';
import 'package:task_paloma365/service/sqlite.dart';

import '../global.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderStateNotInitialized()) {
    on<OrderEvent>(
      (event, emit) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final Database db = await LocalDb.open();
        if (event is OrderEventGet) {
          List<Map<String, dynamic>> orders = await getOrders(db);
          final currentOrderId = prefs.getInt(currentOrderIdStorageKey);
          emit(OrderStateCompleted(orders, currentOrderId));
        }

        if (event is OrderEventCreate) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          int id = await createOrder(db, place: event.place);
          await prefs.setInt(currentOrderIdStorageKey, id);
          add(OrderEventGet());
          cartBloc.add(CartEventGet());
        }
      },
    );
  }
}

class OrderEventGet extends OrderEvent {}

class OrderEventCreate extends OrderEvent {
  OrderEventCreate(this.place);

  final String place;
}

class OrderStateNotInitialized extends OrderState {}

class OrderStateLoading extends OrderState {}

class OrderStateCompleted extends OrderState {
  List<Map<String, dynamic>> orders;
  int? currentOrderId;

  OrderStateCompleted(this.orders, this.currentOrderId);
}

class OrderEvent {}

class OrderState {}
