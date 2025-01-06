import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class HomeEtudiant extends StatefulWidget {
  
  const HomeEtudiant({super.key, });

  @override
  State<HomeEtudiant> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeEtudiant> {
  final PageController _pageController = PageController(initialPage: 0);
  void initState() {
    super.initState();
  }



  @override
 Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
  backgroundColor: Color(0xFF202149),
  body: 
    SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                child: Icon(Icons.account_circle_rounded , size: 100, color: Colors.white,)
           ),
            ),
           SizedBox(height: 10 ),
            Container( 
              margin: EdgeInsets.only(left: 10),                             
              child: Text('Hi , Username', style: TextStyle(
                color: Colors.white , 
                fontWeight: FontWeight.w700 , 
                fontSize: 16
              ),),
            ), 
             SizedBox(height: 5),
             Text('gnakale19@gmail.com.......', style: TextStyle(
              fontWeight: FontWeight.w400 ,
              fontSize: 12,
              color: Colors.white
             ),),
             SizedBox(height: 30),
             Container(         
              padding: EdgeInsets.only(top: 40 , left: 30),     
              width: double.infinity,
              height: 500,
                decoration: BoxDecoration(
                   boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3), 
                spreadRadius: 6, 
                blurRadius: 24, 
                offset: Offset(0, 5), 
              ),
            ],
                  color: Colors.white,
         borderRadius: BorderRadius.circular(20),
          ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Card(
                      color: Colors.red,
          elevation: 8, 
          shadowColor: Color.fromARGB(255, 204, 204, 204),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), 
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20 , bottom: 40 , left: 10 , right: 150), 
            child: Row(
              children: [
                Icon(
                  Icons.view_timeline_outlined,
                  size: 50,
                  color: Color.fromARGB(255, 255, 255, 255), 
                ),
                SizedBox(width: 16), 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TimeTable",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 8), 
                    Text(
                      "Sous-titre ",
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
        ),
        SizedBox(width: 15,),
        
                    ],
                  ),
                  SizedBox(height: 15,) ,
                     Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    GestureDetector(
                      onTap: (){
                       
                      } ,
                      child: Card(               
                        color: Colors.red,
                                elevation: 8, 
                                 shadowColor: const Color.fromARGB(255, 216, 216, 216),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), 
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20 , bottom: 40 , left: 10 , right: 160), 
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_3_sharp,
                                        size: 50,
                                        color: Colors.white, 
                                      ),
                                      SizedBox(width: 16), 
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                      Text(
                        "Presence",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 8), 
                      Text(
                        "Sous-titre ",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                                        ],
                                      ),
                                    ],
                                  ),
                      
                                ),
                              ),
                    ),
        
                    ],
                  ),
                  SizedBox(height: 15,),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Card(
                      
                      color: Colors.red,
          elevation: 8,
           shadowColor: const Color.fromARGB(255, 231, 231, 231),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), 
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20 , bottom: 40 , left: 10 , right: 170), 
            child: Row(
              children: [
                Icon(
                 Icons.person_remove_alt_1_rounded,
                  size: 50,
                  color: Color.fromARGB(255, 255, 255, 255), 
                ),
                SizedBox(width: 16), 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Missing",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 8), 
                    Text(
                      "Sous-titre ",
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
        ),
        
                    ],
                  ),
                ],
              ),
             )
        
          ],
        ),
      ),
    );
    
    
  }
}