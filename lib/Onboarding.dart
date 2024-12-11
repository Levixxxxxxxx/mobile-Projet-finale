import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifrantrackln/intro_screens/page_1.dart';
import 'package:ifrantrackln/intro_screens/page_2.dart';
import 'package:ifrantrackln/intro_screens/page_3.dart';
import 'package:ifrantrackln/pages/login/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _controller = PageController();

 bool onlastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
         PageView(
          controller: _controller,
          onPageChanged: (index){
              setState(() {
                onlastPage = index == 2;
              });
          },
          children: [
           IntroPage1(),
           IntroPage2(),
           IntroPage3(),
          ],
        ), 
        Container(
          alignment: Alignment(0, 0.75),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              onlastPage
             ? GestureDetector(
                onTap: () {
                  _controller.jumpToPage( 2);
                },
                child: Text("Skip", style: TextStyle(fontWeight: FontWeight.w700 , color: Colors.white),)
                ): GestureDetector(
                onTap: () {
                  _controller.jumpToPage( 2);
                },
                child: Text("Skip", style: TextStyle(fontWeight: FontWeight.w700 , ),)
                ),
           SmoothPageIndicator(controller: _controller, count: 3) ,
            
            onlastPage
            ? GestureDetector(
                  onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Login();
                 }));
                },
              child: Text("Done", style: TextStyle(fontWeight: FontWeight.w700 , color: Colors.white),)
              ):  GestureDetector(
                  onTap: () {
                  _controller.nextPage( duration: Duration(milliseconds: 500), curve: Curves.easeIn );
                },
              child: Text("Next", style: TextStyle(fontWeight: FontWeight.w700),)
              )
             
          ] 
          
          ))
        ] 
      ),
    );
  }
}