import 'package:flutter/material.dart';
import 'package:ifrantrackln/pages/etudiant/home.dart';
import 'package:ifrantrackln/pages/etudiant/missing.dart';
import 'package:ifrantrackln/pages/etudiant/prseence.dart';
import 'package:ifrantrackln/pages/etudiant/timetable.dart';
import 'package:http/http.dart' as http;
import 'package:ifrantrackln/pages/login/login.dart';
import 'dart:convert';

class MainscreenEtudiant extends StatefulWidget {
final String token;

  const MainscreenEtudiant({super.key, required this.token});

  @override
  State<MainscreenEtudiant> createState() => _MainscreenState();
}



class _MainscreenState extends State<MainscreenEtudiant> {
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   bool isLoading = true;
Map<String, dynamic>? userData;
  Widget _currentPage = HomeEtudiant();


 @override
  void initState() {
    super.initState();
      recupererDonneesUtilisateur();
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
              child:  Column(
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
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
               setState(() {
                  _currentPage = HomeEtudiant();
                });
                 _scaffoldKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Icons.view_timeline_outlined),
              title: Text('TimeTable'),
              onTap: () {
                setState(() {
                  _currentPage = Timetable(token: widget.token);
                });
                  _scaffoldKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Icons.person_3_sharp),
              title: Text('Presence'),
              onTap: () {
               setState(() {
                  _currentPage = Presence(token: widget.token);
                });
                 _scaffoldKey.currentState?.closeDrawer();
              },
            ),
              ListTile(
              leading: Icon(Icons.person_remove_alt_1_rounded),
              title: Text('Missing'),
              onTap: () {
                  setState(() {
                  _currentPage = Missing(token: widget.token);
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
      body: _currentPage,
    );
  }
}