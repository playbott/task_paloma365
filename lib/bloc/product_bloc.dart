import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_paloma365/service/queries.dart';
import 'package:task_paloma365/service/sqlite.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductStateNotInitialized()) {
    on<ProductEvent>(
      (event, emit) async {
        final Database db = await LocalDb.open();
        if (event is ProductEventGet) {
          emit(ProductStateLoading());
          await Future.delayed(const Duration(seconds: 1));
          final products = await getProducts(db);
          emit(ProductStateCompleted(products));
        }
      },
    );
  }
}

class ProductEventGet extends ProductEvent {}

class ProductStateNotInitialized extends ProductState {}

class ProductStateLoading extends ProductState {}

class ProductStateCompleted extends ProductState {
  List<Map<String, dynamic>> products;

  ProductStateCompleted(this.products);
}

class ProductEvent {}

class ProductState {}
