
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsEtudiant extends StatefulWidget {
  final int userId;
  final String token;
  final int classe;
 final String name; 
  final String lastname;
  
const DetailsEtudiant({super.key, required this.userId, required this.token, required this.classe , required this.name , required this.lastname });


  @override
  State<DetailsEtudiant> createState() => _DetailsEtudiantState();
}

class _DetailsEtudiantState extends State<DetailsEtudiant> {
  bool isLoading = true;
  String? selectedDay;
  String? selectedFeature; // Pour savoir quelle carte est sélectionnée
  Map<String, dynamic>? userData;
  Map<String, dynamic>? timetableData;
Map<String, dynamic>? absenceData;
bool _isExpanded1 = false; // État pour le premier panneau
  bool _isExpanded2 = false; // État pour le deuxième panneau
  bool _isExpanded3 = false; // État pour le troisième panneau
  Map<String, dynamic>? presenceData;
 Map<String, dynamic>?  presence2Data ;
  Map<String, dynamic>?  presence3Data ;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

@override
void didUpdateWidget(covariant DetailsEtudiant oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.userId != oldWidget.userId) {
    // Si l'utilisateur a changé, recharge les données
    setState(() {
      isLoading = true;
    });
    fetchData();
  }
}


  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
    await emploietemps();
    await absence();
       presence();
    presence2();
    presence3();
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

  Future<void> emploietemps() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/timetable/${widget.classe}/${userData?["data"]["currentYear"]["id"]}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        timetableData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print('Erreur de récupération des données emploi du temps: ${response.statusCode}');
    }
  }

 Future<void> absence( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/list/absences/student/${widget.userId}'),
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

 Future<void> presence( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${widget.userId}/1'),
       headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ); 
   print(' absence ${response3.statusCode}');
      if (response3.statusCode == 200) {
       setState(() {
        presenceData = jsonDecode(response3.body);  
        isLoading = false;       
      });
      return jsonDecode(response3.body);
      
    } else {
       print(" annees ${presenceData?["data"]}");
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }



 Future<void> presence2( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${widget.userId}/2'),
       headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ); 
   print(' absence2 ${response3.statusCode}');
      if (response3.statusCode == 200) {
       setState(() {
        presence2Data = jsonDecode(response3.body);  
        isLoading = false;       
      });
      return jsonDecode(response3.body);
      
    } else {
       print(" annees ${presence2Data?["data"]}");
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }




 Future<void> presence3( ) async {
   
    final  response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/presence/student/year_segment/${widget.userId}/3'),
       headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ); 
   print(' absence ${response3.statusCode}');
      if (response3.statusCode == 200) {
       setState(() {
        presence3Data = jsonDecode(response3.body);  
        isLoading = false;       
      });
      return jsonDecode(response3.body);
      
    } else {
       print(" annees ${presence3Data?["data"]}");
      print('Erreur de récupération des données emploie du temps: ${response3.statusCode}');        
      return null;
    }
 }





  String _dayToString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    var nname = widget.name ;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    ' student  Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 20),
                  // Les trois cartes (emploi du temps, présence, absences)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFeature = "timetable";
                          });
                        },
                        child: Card(
                          color: selectedFeature == "timetable" ? const Color(0xFF202149) : Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 30,
                                  color: selectedFeature == "timetable" ? Colors.white : Colors.black,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Timetable",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: selectedFeature == "timetable" ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFeature = "presence";
                          });
                        },
                        child: Card(
                          color: selectedFeature == "presence" ? const Color(0xFF202149) : Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: selectedFeature == "presence" ? Colors.white : Colors.black,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Presence",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: selectedFeature == "presence" ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFeature = "absence";
                          });
                        },
                        child: Card(
                          color: selectedFeature == "absence" ? const Color(0xFF202149) : Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 30,
                                  color: selectedFeature == "absence" ? Colors.white : Colors.black,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Missing",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: selectedFeature == "absence" ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Affichage du contenu selon la carte sélectionnée
                  if (selectedFeature == "timetable") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (String day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = day;
                              });
                            },
                            child: Card(
                              color: selectedDay == day
                                  ? const Color(0xFF202149)
                                  : const Color.fromARGB(255, 224, 238, 253),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: selectedDay == day ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    selectedDay != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: timetableData?["data"]["seances"]
                                    ?.where((seance) {
                                      final date = DateTime.parse(seance["date"]);
                                      return _dayToString(date.weekday).toLowerCase() ==
                                          selectedDay!.toLowerCase();
                                    })
                                    .length ??
                                0,
                            itemBuilder: (context, index) {
                              final filteredSeances = timetableData?["data"]["seances"]
                                  ?.where((seance) {
                                    final date = DateTime.parse(seance["date"]);
                                    return _dayToString(date.weekday).toLowerCase() ==
                                        selectedDay!.toLowerCase();
                                  })
                                  .toList();
                              final seance = filteredSeances?[index];
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    seance?["module"]["label"] ?? "Unknown Module",
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    'Type: ${seance?["type_seance"]["label"] ?? ""} | ${seance?["heure_debut"] ?? ""} - ${seance?["heure_fin"] ?? ""} | Salle: ${seance?["salle"]["label"] ?? ""}',
                                    style: const TextStyle(color: Colors.blueGrey),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Text(
                            'Sélectionnez un jour pour voir les séances.',
                            style: TextStyle(fontSize: 16),
                          ),
                  ] else if (selectedFeature == "presence") ...[
                  

Column(
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
                  title: Text('Semester 1'),
                );
              },
              body: ListTile(
                title:   presenceData?["data"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:presenceData?["data"].length,
          itemBuilder: (context, index){
            final Npresence = presenceData?["data"][index];
            return ListTile(
             title: Text( "Attendance Rate ${Npresence["attendanceRate"]} %" ),
             subtitle: Text(
            ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '
             ),
             leading: Text(' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
            );          
          },
         )
          : Text('Aucune presence'),
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
                  title: Text('Semester 2'),
                );
              },
              body: ListTile(
                title:   presence2Data?["data"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:presence2Data?["data"].length,
          itemBuilder: (context, index){
            final Npresence = presence2Data?["data"][index];
            return ListTile(
             title: Text( "Attendance Rate ${Npresence["attendanceRate"]} %" ),
             subtitle: Text(
            ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '
             ),
             leading: Text(' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
            );          
          },
         )
          : Text('Aucune presence'),
              ),
              isExpanded: _isExpanded2,
              canTapOnHeader: true, // Permet de cliquer sur l'en-tête
            ),
          ],
          
            ),
        ),
          Center(
              child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
             setState(() {
              _isExpanded3 = !_isExpanded3; // Basculer l'état du panneau
            });
          },
         children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Semester 3'),
                );
              },
              body:ListTile(
                title:   presence3Data?["data"] != null 
         ? ListView.builder(
          shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
          itemCount:presence3Data?["data"].length,
          itemBuilder: (context, index){
            final Npresence = presence3Data?["data"][index];
            return ListTile(
             title: Text( "Attendance Rate ${Npresence["attendanceRate"]} %" ),
             subtitle: Text(
            ' workedHours = ${Npresence["workedHours"]}  missedHours = ${Npresence["missedHours"]}  '
             ),
             leading: Text(' Start : ${Npresence["start"]}\nEnd : ${Npresence["end"]} '),
            );          
          },
         )
          : Text('Aucune presence'),
              ),
              isExpanded: _isExpanded3,
              canTapOnHeader: true, // Permet de cliquer sur l'en-tête
            ),
          ],
          
            ),
        )
          ],
          
        )


                  ] else if (selectedFeature == "absence") ...[
                   Column(
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
                  ],
                ],
              ),
            ),
    );
  }
}
