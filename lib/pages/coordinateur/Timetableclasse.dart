import 'package:flutter/material.dart';

class Timetableclasse extends StatefulWidget {
  final int id;
  const Timetableclasse({super.key, required this.id});

  @override
  State<Timetableclasse> createState() => _TimetableclasseState();
}

class _TimetableclasseState extends State<Timetableclasse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
         body: SingleChildScrollView(
          child: Text('daet'),
         ),
    );
  }
}