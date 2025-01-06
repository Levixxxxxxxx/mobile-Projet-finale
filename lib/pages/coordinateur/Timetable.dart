import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeCoordinateur extends StatefulWidget {
  final String token;
  const HomeCoordinateur({super.key, required this.token});

  @override
  State<HomeCoordinateur> createState() => _HomeCoordinateurState();
}

class _HomeCoordinateurState extends State<HomeCoordinateur> {
  Map<String, dynamic>? classeData;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  Map<String, dynamic>? selectedClasse;
  int? classeid;
  String? selectedTimetableType; 
  String? selectedDay;
  Map<String, dynamic>? timetableData;
  Map<String, dynamic>? pastTimetableData;
  Map<String, dynamic>? upcomingData;
  int? timetableid;
  String? selectedweek;
  Map<String, dynamic>? selectedTimetableData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await recupererDonneesUtilisateur();
    await classe();
  }

  Future<void> createTimetable(Map<String, dynamic> timetableData) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/trackin/timetable'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(timetableData),
    );

    if (response.statusCode == 201) {
      print("Emploi du temps créé avec succès");
      upcomingemploietemps(); // Rafraîchissez les données
    } else {
      print(
          "Erreur lors de la création de l'emploi du temps: ${response.body}");
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
      print(
          'Erreur de récupération des données utilisateur: ${response.statusCode}');
      return null;
    }
  }

  Future<void> classe() async {
    final response3 = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/list/classes'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response3.statusCode == 200) {
      setState(() {
        classeData = jsonDecode(response3.body);
        isLoading = false;
      });
      return jsonDecode(response3.body);
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response3.statusCode}');
      return null;
    }
  }

  Future<void> emploietemps() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/timetable/${classeid}/${userData?["data"]["currentYear"]["id"]}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print('mieuxx ${response.statusCode}');
    print('mieuxx ${classeid}');
    if (response.statusCode == 200) {
      setState(() {
        timetableData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response.statusCode}');
    }
  }

  Future<void> pastemploietemps() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/timetable/${classeid}/${userData?["data"]["currentYear"]["id"]}/-1'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print('mieuxx ${response.statusCode}');
    print('mieuxx ${classeid}');
    if (response.statusCode == 200) {
      setState(() {
        pastTimetableData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response.statusCode}');
    }
  }

  Future<void> selectedemploietemps() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/trackin/timetable/${timetableid}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    print('mieuxx ${response.statusCode}');
    print('mieuxx ${classeid}');
    if (response.statusCode == 200) {
      setState(() {
        selectedTimetableData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response.statusCode}');
    }
  }

  Future<void> upcomingemploietemps() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/trackin/timetable/${classeid}/${userData?["data"]["currentYear"]["id"]}/1'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        upcomingData = {
          "data": (data["data"] as List).where((item) {
            final startDate = DateTime.parse(item["date_debut"]);
            return startDate.isAfter(DateTime.now());
          }).toList()
            ..sort((a, b) {
              final dateA = DateTime.parse(a["date_debut"]);
              final dateB = DateTime.parse(b["date_debut"]);
              return dateA.compareTo(dateB);
            }),
        };
        isLoading = false;
      });
    } else {
      print(
          'Erreur de récupération des données emploi du temps: ${response.statusCode}');
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
    return Scaffold(
      backgroundColor: const Color(0xFF202149),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
              
                if (selectedClasse == null && selectedTimetableType == null)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Timetable',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.3),
                                spreadRadius: 6,
                                blurRadius: 24,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            color: Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          child: classeData?["data"] != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: classeData?["data"].length,
                                  itemBuilder: (context, index) {
                                    final Nclasse = classeData?["data"][index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedClasse = Nclasse;
                                          classeid = Nclasse["id"];
                                          emploietemps();
                                          pastemploietemps();
                                          upcomingemploietemps();
                                        });
                                      },
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(
                                            255, 216, 216, 216),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${Nclasse['label']}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "${Nclasse['filiere']['label']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Text('Aucune classe'),
                        ),
                      ],
                    ),
                  ),
                // Détails de la classe sélectionnée
                if (selectedClasse != null && selectedTimetableType == null)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 24,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      color: Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              selectedClasse = null;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "${selectedClasse?['label']}",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimetableType = "current";
                            });
                          },
                          child: timetableCard("Current Timetable",
                              "Find out about all the sessions in your current timetable"),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimetableType = "past";
                            });
                          },
                          child: timetableCard("Past Timetable",
                              "Find out about all the sessions in your past timetable"),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimetableType = "upcoming";
                            });
                          },
                          child: timetableCard("Upcoming Timetable",
                              "Find out about all the sessions in your upcoming timetable"),
                        ),
                      ],
                    ),
                  ),
                // Contenu spécifique au type d'emploi du temps
                if (selectedTimetableType != null)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 24,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      color: Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              selectedTimetableType = null;
                            });
                          },
                        ),
                        Center(
                          child: Text(
                            "${selectedTimetableType?.toUpperCase()} Timetable ",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Builder(
                              builder: (context) {
                                if (selectedTimetableType == "current") {
                                  return Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for (String day in [
                                          'Monday',
                                          'Tuesday',
                                          'Wednesday',
                                          'Thursday',
                                          'Friday'
                                        ])
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedDay = day;
                                              });
                                            },
                                            child: Card(
                                              color: selectedDay == day
                                                  ? const Color(0xFF202149)
                                                  : const Color.fromARGB(
                                                      255, 224, 238, 253),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  day,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedDay == day
                                                        ? Colors.white
                                                        : Colors.black,
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
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: timetableData?["data"]
                                                        ["seances"]
                                                    ?.where((seance) {
                                                  final date = DateTime.parse(
                                                      seance["date"]);
                                                  return _dayToString(
                                                              date.weekday)
                                                          .toLowerCase() ==
                                                      selectedDay!
                                                          .toLowerCase();
                                                }).length ??
                                                0,
                                            itemBuilder: (context, index) {
                                              final filteredSeances =
                                                  timetableData?["data"]
                                                          ["seances"]
                                                      ?.where((seance) {
                                                final date = DateTime.parse(
                                                    seance["date"]);
                                                return _dayToString(
                                                            date.weekday)
                                                        .toLowerCase() ==
                                                    selectedDay!.toLowerCase();
                                              }).toList();
                                              final seance =
                                                  filteredSeances?[index];
                                              return Card(
                                                child: ListTile(
                                                  title: Text(
                                                    seance?["module"]
                                                            ["label"] ??
                                                        "Unknown Module",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  subtitle: Text(
                                                    'Type: ${seance?["type_seance"]["label"] ?? ""} | ${seance?["heure_debut"] ?? ""} - ${seance?["heure_fin"] ?? ""} | Salle: ${seance?["salle"]["label"] ?? ""}',
                                                    style: const TextStyle(
                                                        color: Colors.blueGrey),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : const Text(
                                            'Sélectionnez un jour pour voir les séances.',
                                            style: TextStyle(fontSize: 16),
                                          )
                                  ]);
                                } else if (selectedTimetableType == "past" &&
                                    selectedweek == null) {
                                  return pastTimetableData != null
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              pastTimetableData?["data"].length,
                                          itemBuilder: (context, index) {
                                            final Npast =
                                                pastTimetableData?["data"]
                                                    [index];
                                            return GestureDetector(
                                              onTap: () {
                                                timetableid = Npast["id"];
                                                print(Npast["id"]);
                                                selectedemploietemps();
                                                selectedweek = '1';
                                              },
                                              child: Card(
                                                child: ListTile(
                                                  title: Text('Timetable'),
                                                  subtitle: Text(
                                                    '${Npast["date_debut"]} - ${Npast["date_fin"]} ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Text('Aucun PastTimetable ');
                                } else if (selectedTimetableType ==
                                        "upcoming" &&
                                    selectedweek == null) {
                                  return pastTimetableData != null
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              upcomingData?["data"].length,
                                          itemBuilder: (context, index) {
                                            final Nupcoming =
                                                upcomingData?["data"][index];
                                            return Column(children: [
                                              FloatingActionButton(
                                                onPressed:
                                                    showCreateTimetableDialog,
                                                child: Icon(Icons.add),
                                                tooltip:
                                                    'Créer un nouvel emploi du temps',
                                              ),
                                              SizedBox(height: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    timetableid =
                                                        Nupcoming["id"];
                                                    print(Nupcoming["id"]);
                                                    selectedemploietemps();
                                                    selectedweek = '1';
                                                  });
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text('Timetable'),
                                                    subtitle: Text(
                                                      '${Nupcoming["date_debut"]} - ${Nupcoming["date_fin"]} ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]);
                                          },
                                        )
                                      : Text('Aucun UpcomingTimetable ');
                                } else {
                                  return Text(
                                    "Aucun contenu disponible.",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (selectedweek != null)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 24,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      color: Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              selectedweek = null;
                            });
                          },
                        ),
                        Column(
                          children: [
                            Text('Timetable',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25,
                                )),
                            Text(
                              '(${selectedTimetableData?["data"]["date_debut"]} - ${selectedTimetableData?["data"]["date_fin"]})',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (String day in [
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday'
                                ])
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDay = day;
                                      });
                                    },
                                    child: Card(
                                      color: selectedDay == day
                                          ? const Color(0xFF202149)
                                          : const Color.fromARGB(
                                              255, 224, 238, 253),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: selectedDay == day
                                                ? Colors.white
                                                : Colors.black,
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: selectedTimetableData?["data"]
                                                ["seances"]
                                            ?.where((seance) {
                                          final date =
                                              DateTime.parse(seance["date"]);
                                          return _dayToString(date.weekday)
                                                  .toLowerCase() ==
                                              selectedDay!.toLowerCase();
                                        }).length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      final filteredSeances =
                                          selectedTimetableData?["data"]
                                                  ["seances"]
                                              ?.where((seance) {
                                        final date =
                                            DateTime.parse(seance["date"]);
                                        return _dayToString(date.weekday)
                                                .toLowerCase() ==
                                            selectedDay!.toLowerCase();
                                      }).toList();
                                      final seance = filteredSeances?[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            seance?["module"]["label"] ??
                                                "Unknown Module",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          subtitle: Text(
                                            'Type: ${seance?["type_seance"]["label"] ?? ""} | ${seance?["heure_debut"] ?? ""} - ${seance?["heure_fin"] ?? ""} | Salle: ${seance?["salle"]["label"] ?? ""}',
                                            style: const TextStyle(
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Text(
                                    'Sélectionnez un jour pour voir les séances.',
                                    style: TextStyle(fontSize: 16),
                                  )
                          ],
                        )
                      ],
                    ),
                  )
              ],
            ),
    );
  }

  Widget timetableCard(String title, String subtitle) {
    return Card(
      color: Color.fromARGB(255, 117, 137, 255),
      elevation: 8,
      shadowColor: const Color.fromARGB(255, 216, 216, 216),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 207, 207, 207),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCreateTimetableDialog() {
  final _formKey = GlobalKey<FormState>();
  String? startDate, endDate;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Créer un emploi du temps'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Date de début (YYYY-MM-DD)'),
                onSaved: (value) => startDate = value,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date de fin (YYYY-MM-DD)'),
                onSaved: (value) => endDate = value,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Créer'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final newTimetable = {
                  "timetable": {
                    "classe_id": classeid,
                    "date_debut": "$startDate 00:00:00",
                    "date_fin": "$endDate 23:59:59",
                  },
                  "seances": [] 
                };

                createTimetable(newTimetable);
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}
}
