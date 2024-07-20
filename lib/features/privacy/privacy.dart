import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            spreadRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: const Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: Text('Privacy'),
        ),
      ),
    );
  }
}
