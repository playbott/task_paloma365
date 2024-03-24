import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_bloc.dart';
import 'product_bloc.dart';
import 'order_bloc.dart';

List<BlocProvider> providers = [
  BlocProvider(lazy: false, create: (_) => productBloc),
  BlocProvider(lazy: false, create: (_) => orderBloc),
  BlocProvider(lazy: false, create: (_) => cartBloc),
];

ProductBloc productBloc = ProductBloc();
OrderBloc orderBloc = OrderBloc();
CartBloc cartBloc = CartBloc();
