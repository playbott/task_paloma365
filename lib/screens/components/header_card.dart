import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 215, 173, 1.0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black26),
        ],
      ),
      width: 170,
      height: 110,
      padding: const EdgeInsets.all(10),
      child: Text(title, style: TextStyle(fontSize: 20),),
    );
  }
}
