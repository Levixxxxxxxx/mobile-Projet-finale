import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homeparent extends StatefulWidget {
  const Homeparent({super.key});

  @override
  State<Homeparent> createState() => _HomeparentState();
}

class _HomeparentState extends State<Homeparent> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                'WELCOME TO THE IFRAN PARENT AREA',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'With its hands-on teaching approach. IFRAN is developing a professionalized teaching program to help train Africa elite.',
              ),
            ),
            SizedBox(height: 25),
             Text('News', style: TextStyle(
              fontWeight: FontWeight.w700 ,
              fontSize: 24,
             ),),
             SizedBox(height: 25),
            // Ajout du carrousel d'images
            Container(
              height: 400, // Hauteur du carrousel
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0, // flou de l'ombre
                            offset: Offset(0, 5), // déplacement de l'ombre
                          ),
                        ],
                         ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('assets/new1.jpg', fit: BoxFit.cover),
                    ),
                  ),
                 ), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                     child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0, // flou de l'ombre
                            offset: Offset(0, 5), // déplacement de l'ombre
                          ),
                        ],
                      ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('assets/new2.jpg', fit: BoxFit.cover),
                    ),
                  ),
                   ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0, // flou de l'ombre
                            offset: Offset(0, 5), // déplacement de l'ombre
                          ),
                        ],
                      ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('assets/new3.png', fit: BoxFit.cover),
                    ),
                  ),
                 ), 
                ],
              ),
            ),

            SizedBox(height: 20), // Espace après le carrousel
          ],
        ),
      ),
    );
  }
}
