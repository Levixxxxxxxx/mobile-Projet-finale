import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ifrantrackln/pages/login/login.dart';
import 'package:ifrantrackln/pages/parent/detailsEtudiant.dart';
import 'package:ifrantrackln/pages/parent/home.dart';

class MainscreenParent extends StatefulWidget {
  final String token;
  const MainscreenParent({super.key, required this.token});

  @override
  State<MainscreenParent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainscreenParent> {
  Map<String, dynamic>? userData;
Map<String, dynamic>? childrenData;
  bool isLoading = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _currentPage = Homeparent();


@override
  void initState() {
    super.initState();
 fetchData();
  }

  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
   parentEtudiant();
   
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      } else {
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




Future<Map<String, dynamic>?> parentEtudiant() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/list/parent/children/${userData?["data"]["user"]["id"]}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
       setState(() {
        childrenData = jsonDecode(response.body);  
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
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        leading: Builder(
          builder: (context) => IconButton(
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
                color: Color(0xFF202149),
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
                      _currentPage = Homeparent();
                    });
                    _scaffoldKey.currentState?.closeDrawer();
                  },
                ),
            
            ExpansionTile(
              leading: Icon(Icons.people),
              title: Text('Children'),
              children: [
                childrenData?["data"] != null 
          ?ListView.builder(
              shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
         itemCount: childrenData?["data"].length,
            itemBuilder: (context, index){
              final children = childrenData?["data"][index];
              final childrenc = children?["classe"][0];
              return              
                    ListTile(
                  title: Text('${children["name"]} ${children["lastname"]} ', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),),
                    onTap: () {
  setState(() {
    _currentPage = DetailsEtudiant(
      key: UniqueKey(), // Forcer le rafraîchissement
      userId: children["id"],
      token: widget.token,
      classe: childrenc["id"],
      name: children["name"],
      lastname: children["lastname"],
    );
  });
},
                );     
            }
            ): Text('aucun enfant'),
              ],
            ),      
                ListTile(
                       leading: Icon(Icons.login_rounded, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
                
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
