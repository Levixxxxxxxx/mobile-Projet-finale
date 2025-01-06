import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifrantrackln/pages/coordinateur/Graphic.dart';
import 'package:ifrantrackln/pages/coordinateur/Timetable.dart';
import 'package:ifrantrackln/pages/coordinateur/session.dart';
import 'package:ifrantrackln/pages/coordinateur/user.dart';
import 'dart:convert';
import 'package:ifrantrackln/pages/login/login.dart';
// moi
class MainscreenCoordinator extends StatefulWidget {
  final String token;
  const MainscreenCoordinator({super.key ,  required this.token});

  @override
  State<MainscreenCoordinator> createState() => _MainscreenCoordinatorState();
}

class _MainscreenCoordinatorState extends State<MainscreenCoordinator> {
   bool isLoading = true;
    Widget _currentPage = CoordinatorSession(token: 'token') ;
Map<String, dynamic>? userData;
 GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
 @override
  void initState() {
    super.initState();
      recupererDonneesUtilisateur();
     _currentPage = CoordinatorSession(token:  widget.token);   
  }



Future<void> deconnexion(BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/logout'),
       headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print("${widget.token}");
  print('Statut HTTP: ${response.statusCode}');
  try {
      if (response.statusCode == 200) {
      
      // Gérer la déconnexion réussie
     Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
    } else {
      // Gérer l'échec de la déconnexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Déconnexion échouée. Veuillez réessayer.')),
      );
    }
  } catch (e) {
      print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue.')),
      );
  }  
  
  }

 Future<Map<String, dynamic>?> recupererDonneesUtilisateur() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/logged_user/infos'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
       setState(() {
        userData = jsonDecode(response.body);  
        isLoading = false;
        
      });
          
      return jsonDecode(response.body);
 

    } else {
      // Si la requête échoue, retourner null
      print('Erreur de récupération des données utilisateur: ${response.statusCode}');
      return null;
    }
  
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
 appBar: AppBar(
    backgroundColor: Color(0xFF202149),
        title: Text(''),
        leading: Builder(
          builder: (context) => IconButton(
            color: Colors.white,
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color:Color(0xFF202149),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage('assets/user.png')
                  ) , 
                  SizedBox(height: 10,),
                  Text(' ${userData?["data"]["user"]["name"]}  ${userData?["data"]["user"]["lastname"]}', style: TextStyle(color: Colors.white , fontWeight: FontWeight.w700  , fontSize: 20)),
                  
                ],
              )
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Session'),
              onTap: () {
                 setState(() {
                  _currentPage = CoordinatorSession(token: widget.token);
                });
                 _scaffoldKey.currentState?.closeDrawer();
              },
            ),
             ListTile(
              leading: Icon(Icons.view_timeline_outlined),
              title: Text('Timetable'),
              onTap: () {
                 setState(() {
                  _currentPage = HomeCoordinateur(token: widget.token);
                });
                 _scaffoldKey.currentState?.closeDrawer();
              },
            ),
             ListTile(
              leading: Icon(Icons.person_3_sharp),
              title: Text('User'),
              onTap: () {
                     setState(() {
                  _currentPage = User(token: widget.token);
                });

                 _scaffoldKey.currentState?.closeDrawer();
              },
            ),
               ListTile(
              leading: Icon(Icons.graphic_eq),
              title: Text('Graphic'),
              onTap: () {
                     setState(() {
                  _currentPage = Graphic(token: widget.token);
                });

                 _scaffoldKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Icons.login_rounded, color: Colors.red,),
              title: Text('Logout', style: TextStyle(
                color: Colors.red,
              ),),
              onTap: () {
              deconnexion(context);
            },
            ),
          ],
        ),
      ),
      body: _currentPage
    );
  }
}