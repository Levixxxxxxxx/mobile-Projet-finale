import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Missing extends StatefulWidget {
  final String token;
  const Missing({super.key, required this.token});

  @override
  State<Missing> createState() => _MissingState();
}

class _MissingState extends State<Missing> {
bool _isExpanded1 = false; // État pour le premier panneau
  bool _isExpanded2 = false; // État pour le deuxième panneau
   bool isLoading = true;
Map<String, dynamic>? userData;
Map<String, dynamic>? absenceData;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
    absence();
    
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


 Future<void> absence( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/list/absences/student/${userData?["data"]["user"]["id"]}'),
       headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ); 
   print(' absence ${response3.statusCode}');
      if (response3.statusCode == 200) {
       setState(() {
        absenceData = jsonDecode(response3.body);  
        isLoading = false;       
      });
      return jsonDecode(response3.body);
    } else {
       print(" annees ${absenceData?["data"]["user"]["classe"]["id"]}");
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9), 
      body: SingleChildScrollView(
        child: Column(
          children: [
              Center(
              child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
             setState(() {
              _isExpanded1 = !_isExpanded1; // Basculer l'état du panneau
            });
          },
         children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Unjustified Absence' , style: TextStyle(
                    fontWeight: FontWeight.w700 , 
                   color: Color.fromARGB(255, 0, 24, 88)
                  ),),
                );
              },
              body: ListTile(
                title:   absenceData?["data"]["notjustified"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:absenceData?["data"]["notjustified"].length,
          itemBuilder: (context, index){
            final Nabsence = absenceData?["data"]["notjustified"][index];
            return ListTile(
             title: Text(Nabsence["type_seance"]),
             subtitle: Text(
            '${Nabsence["seance_heure_debut"]} - ${Nabsence["seance_heure_fin"]} '
             ),
            );          
          },
         )
          : Text('Aucune absence non justifiee.'),
              ),
              isExpanded: _isExpanded1,
              canTapOnHeader: true, // Permet de cliquer sur l'en-tête
            ),
          ],
            ),
        ),
         Center(
              child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
             setState(() {
              _isExpanded2 = !_isExpanded2; // Basculer l'état du panneau
            });
          },
         children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Justified Absence' , style: TextStyle(
                    fontWeight: FontWeight.w700 , 
                   color: Color.fromARGB(255, 0, 24, 88)
                  ),),
                );
              },
              body: ListTile(
                title:  absenceData?["data"]["justified"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:absenceData?["data"]["justified"].length,
          itemBuilder: (context, index){
            final absence = absenceData?["data"]["justified"][index];
            return ListTile(
             title: Text(absence["type_seance"]),
             subtitle: Text(
            '${absence["seance_heure_debut"]} - ${absence["seance_heure_fin"]} '
             ),
            );          
          },
         )
          : Text('Aucune absence justifiee.'),
              ),
              isExpanded: _isExpanded2,
              canTapOnHeader: true, // Permet de cliquer sur l'en-tête
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

