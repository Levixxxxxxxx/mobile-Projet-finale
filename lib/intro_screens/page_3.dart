import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {

    return  Container(
           color: Color(0xFF202149),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Lottie.asset('animations/8.json', 
          height: 300 ,
          fit: BoxFit.cover , 
          repeat: true
          ),   
        Text('Innovative Features' , style: TextStyle(fontWeight: FontWeight.w800 , fontSize: 25 , color: Colors.white),) ,
         SizedBox(height:10,),
        Text('discover extraordinary features for a better experience ' ,
         textAlign: TextAlign.center , 
         style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 14 , color: Color.fromARGB(255, 238, 238, 238)) )
          ],
        ),
      ),
    );
  }
}  