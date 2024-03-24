import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.inStock,
    super.key,
  });

  final String title;
  final double price;
  final String imagePath;
  final int inStock;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black26),
        ],
      ),
      width: 170,
      height: 110,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.square(
                dimension: 50,
                child: Image.asset(
                  'res/images/${widget.imagePath}',
                ),
              ),
              Column(
                children: [
                  Text(
                    '₽' + widget.price.toStringAsFixed(2),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Склад: ${widget.inStock}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }
}
