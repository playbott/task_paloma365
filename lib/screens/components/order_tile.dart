import 'package:flutter/material.dart';

import '../../global.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.id,
    required this.createdAt,
    required this.priceSummary,
    required this.place,
  });

  final int id;
  final String createdAt;
  final double priceSummary;
  final String place;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {

      },
      leading: Icon(Icons.check_box),
      title: Text('Посетитель'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          place,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      trailing: Column(
        children: [
          Text(
            '№' +
                id.toString().padLeft(2, '0') +
                '  ' +
                dateFormatHHmm(DateTime.parse(createdAt)),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            '₽' + priceSummary.toStringAsFixed(2),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
    ;
  }
}
