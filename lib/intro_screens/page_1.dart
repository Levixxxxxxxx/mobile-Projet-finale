import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Lottie.asset('animations/1.json', 
          height: 300 ,
          fit: BoxFit.cover , 
          repeat: true
          ),   
        Text('Timing' , style: TextStyle(fontWeight: FontWeight.w800 , fontSize: 25),) ,
           SizedBox(height:10,),
        Text('get to know your schedule, attendance and absences to better manage your program' ,
         textAlign: TextAlign.center , 
         style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 14) )
          ],
        ),
      ),
    );
  }
}