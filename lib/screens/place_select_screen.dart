import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_paloma365/bloc/bloc_providers.dart';
import 'package:task_paloma365/bloc/order_bloc.dart';
import 'package:task_paloma365/screens/components/header_card.dart';
import 'package:task_paloma365/screens/components/place_card.dart';

import '../service/queries.dart';

class PlaceSelectScreen extends StatefulWidget {
  const PlaceSelectScreen({super.key});

  @override
  State<PlaceSelectScreen> createState() => _PlaceSelectScreenState();
}

class _PlaceSelectScreenState extends State<PlaceSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderCard(title: 'Основной зал'),
              SizedBox(
                width: 20,
              ),
              HeaderCard(title: 'Летка'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  orderBloc.add(OrderEventCreate(
                    'VIP 1',
                  ));
                  Navigator.pop(context);
                },
                child: PlaceCard(
                  title: 'VIP 1',
                  icon: Icons.ac_unit,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  orderBloc.add(OrderEventCreate(
                    'VIP 2',
                  ));
                  Navigator.pop(context);
                },
                child: PlaceCard(
                  title: 'VIP 2',
                  icon: Icons.table_bar_sharp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
