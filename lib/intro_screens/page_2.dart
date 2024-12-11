import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE61845),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Lottie.asset('animations/3.json', 
          height: 300 ,
          fit: BoxFit.cover , 
          repeat: true
          ),   
        Text('Management' , style: TextStyle(fontWeight: FontWeight.w800 , fontSize: 25 , color: Colors.white),) ,
         SizedBox(height:10,),
        Text('everything you need to know about school management will be crystal clear' ,
         textAlign: TextAlign.center , 
         style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 14 , color: Color.fromARGB(255, 238, 238, 238)) )
          ],
        ),
      ),
    );
  }
}