import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_paloma365/bloc/bloc_providers.dart';
import 'package:task_paloma365/bloc/cart_bloc.dart';
import 'package:task_paloma365/global.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({
    super.key,
    required this.cartProductId,
    required this.title,
    required this.price,
    required this.count,
  });

  final int cartProductId;
  final String title;
  final double price;
  final int count;

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          cartBloc.add(CartEventUpdateCount(
                              widget.cartProductId, widget.count + 1));
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        )),
                    Container(
                      alignment: Alignment.center,
                      width: 40,
                      padding: EdgeInsets.all(10.0),
                      child: Text(widget.count.toString()),
                    ),
                    IconButton(
                        onPressed: () {
                          cartBloc.add(CartEventUpdateCount(
                              widget.cartProductId, widget.count - 1));
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
