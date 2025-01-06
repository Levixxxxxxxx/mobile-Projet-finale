import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifrantrackln/pages/enseignant/call.dart';
import 'package:ifrantrackln/pages/enseignant/updateClass.dart';
import 'package:intl/intl.dart';
 

class HomeEnseignant extends StatefulWidget {
  final String token;
  const HomeEnseignant({super.key, required this.token});

  @override
  State<HomeEnseignant> createState() => _HomeEnseignantState();
}

class _HomeEnseignantState extends State<HomeEnseignant> {
  Map<String, dynamic>? userData;
  List<dynamic> seanceComming = [];
  List<dynamic> seancePassed = [];
  bool isLoading = true;
  bool showCurrentSession = true; 

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
    await seances();
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
      print('Erreur de récupération des données utilisateur: ${response.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> seances() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/user/seances/${userData?["data"]["user"]["id"]}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        seanceComming = jsonDecode(response.body)['data']['comming'];
        seancePassed = jsonDecode(response.body)['data']['passed'];
        isLoading = false;
      });

      return jsonDecode(response.body);
    } else {
      print('Erreur de récupération des données utilisateur: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202149),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
         
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showCurrentSession = true;
                        });
                      },
                      child: Text('Current Session'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showCurrentSession = false;
                        });
                      },
                      child: Text('Past Session'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                showCurrentSession
                    ? buildSessionList(seanceComming, "Current Sessions", reverse: true)
                    : buildSessionList(seancePassed, "Past Sessions"),
              ],
            ),
          ),
    );
  }



// ...

Widget buildSessionList(List<dynamic> seances, String title, {bool reverse = false}) {
  List<dynamic> displaySeances = reverse ? seances.reversed.toList() : seances;

  return Column(
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              spreadRadius: 6,
              blurRadius: 24,
              offset: Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...displaySeances.map((seance) {
              final int seanceId = seance['id'];
              
              // Parse la date et l'heure avec intl
              final DateTime startTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('${seance['date']} ${seance['heure_debut']}');
              final DateTime endTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('${seance['date']} ${seance['heure_fin']}');

              final bool isPastSession = title == "Past Sessions";
              final DateTime now = DateTime.now();

              // Vérifier si la session est cliquable
              final bool isClickable = isPastSession || now.isAfter(startTime);

              return Card(
                color: isClickable
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Colors.grey.shade300, // Grisé si non cliquable
                child: GestureDetector(
                  onTap: () {
                    if (isClickable) {
                      // Action normale si cliquable
                      if (isPastSession) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpadateForClass(
                              token: widget.token,
                              seanceId: seanceId,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallForClasse(
                              token: widget.token,
                              seanceId: seanceId,
                            ),
                          ),
                        );
                      }
                    } else {
                      // Affiche la Snackbar si non cliquable
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Cette session n’est pas encore disponible.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    title: Text(seance['module']['label']),
                    subtitle: Text(
                        '${seance['date']} - ${seance['heure_debut']} à ${seance['heure_fin']}\nSalle: ${seance['salle']['label']}'),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    ],
  );
}



}
